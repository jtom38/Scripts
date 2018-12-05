
# Import the helper scripts
. .\Src\Directory\Test-DirectoryExists.ps1
. .\src\Directory\Copy-ToDirectory.ps1
. .\src\Directory\Get-DirectoryFileCount.ps1
. .\src\File\Find-OldestFile.ps1
. .\src\File\Remove-FileAndCofirm.ps1
. .\src\File\Get-FileLockStatus.ps1
. .\src\Config\Get-ConfigCredentials.ps1
. .\src\Config\Set-ConfigCredentials.ps1
. .\src\Config\Import-Settings.ps1
. .\src\Convert-ArrayToString.ps1
. .\src\Network\Test-Ping.ps1
. .\src\Get-RemotePath.ps1
. .\src\Search-BackupHold.ps1

# Read the config file and import the values
Import-Settings

# Import LogCsv
Import-Module .\PsLogCsv\PsLogCsv.psm1 -Force
Set-CsvConfig -Config ".\config.json"
Send-CsvMessage -Message "Script has turned on." -Level "Info" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)

While($true){

    # Default the email message to null
    $global:EmailMessage = @()

    # Refresh the config data incase someone made a change while it was active.
    Import-Settings
    Set-CsvConfig -Config ".\config.json"

    # This is a process that never stops looking

    # Test File paths to make sure we are good to go
    $source = Test-DirectoryExists -Path $script:SourceDirectory
    $dest = Test-DirectoryExists -Path $script:DestinationDirectory

    if( $source -eq $true -and $dest -eq $true ) {

        # Flag to state if we did a copy so we can send email notice on it.
        # Each time we loop I want this flag to be reset to false
        $SendEmailNotice = $false

        # Open source and check for files.
        $Databases = [System.IO.Directory]::GetDirectories($script:SourceDirectory)

        # Check each directory per database
        foreach($db in $Databases){

            #Send-CsvMessage -Level "Info" -Message "Looking at Directory: $db" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
            Write-Host "Looking at Directory: $db"
            $BackupType = [System.IO.Directory]::GetDirectories($db)
            foreach($backup in $BackupType){

                #Send-CsvMessage -Level "Info" -Message "Looking at Directory: $backup" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
                Write-Host "Looking at Directory: $backup"
                # Get the files in this directory
                $files = [System.IO.Directory]::GetFiles($backup)

                # Log the number of files found in this folder.
                $filesCount = Get-DirectoryFileCount -DirectoryPath $backup

                if ( $filesCount -ge 1 ){
                    $global:EmailMessage += Send-CsvMessage -Level "Info" -Message "Found $filesCount files in $backup" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
                } else {
                    Write-Host "Found $filesCount file(s) in $backup"
                }

                foreach($file in $files){
                    $global:EmailMessage += Send-CsvMessage -Level "Info" -Message "Checking on $file" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)

                    # Check to see if we have any locks on the file before anything
                    $LockResult = Get-FileLockStatus -File $file
                    if ( $LockResult -eq $true ) {
                        # We have a lock on the file, It might still be generating the file.
                        # Skip it for now, we will come back to it later.
                        $global:EmailMessage += Send-CsvMessage -Level "Info" -Message "$($file) IS locked.  We will pick it up on the next around." -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
                    } else {
                        $global:EmailMessage += Send-CsvMessage -Level "Info" -Message "$($file) NOT locked.  Going to process the file." -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
                    }

                    # Get the comparable path on the remote server
                    $RemotePath =  Get-RemotePath -FilePath $file

                    # Take the remotePath and FileName to generate the new full path
                    $FileInfo = [System.IO.FileInfo]::new($file)
                    $FileName = $FileInfo.Name
                    #$RemoteFile = "$RemotePath\$FileName"

                    # Check to see if the directory exists.  If not, create it
                    if( [System.IO.Directory]::Exists($RemotePath) -eq $false ){
                        [System.IO.Directory]::CreateDirectory($RemotePath) | Out-Null
                    }

                    # We open this loop to double check that we removed all the old files per our folder.
                    $loop = $true
                    while ($loop -eq $true) {
                        # Check number of files in remote directory                        
                        $FileCount = Get-DirectoryFileCount -DirectoryPath $RemotePath

                        # Check the Path that we are working with to see how many files to retain
                        $del = Search-BackupHold -FileDir $FileInfo.Directory -FileCount $FileCount

                        if($del -eq $true){
                            # We need to find the oldest File.
                            $OldestFile = Find-OldestFile -DirectoryPath $RemotePath

                            # Remove it and confirm that it was removed                            
                            Remove-FileAndCofirm -File $OldestFile
                        } else {
                            $loop = $false
                        }
                    }

                    # Now we need to copy our new file over to the remote box                    
                    $CopyResponce = Copy-ToDirectory -File $File -RemotePath $RemotePath -RemoveSource $true

                    # We are not going to set a false flag if we got a true
                    if( $SendEmailNotice -eq $false -and
                        $CopyResponce -eq $true ) {
                            $SendEmailNotice = $true
                    }
                    
                }
            }
        }

        # Email time oh boy
        # We will only send a email if we moved a file around.  Other then that we might have been just waiting for something to happen.
        if ( $SendEmailNotice -eq $true ){
        
            $creds = Get-ConfigCredentials -Config ".\config.json"
    
            $body = Convert-ArrayToString -Array $Global:EmailMessage -AppendValue "`r`n"
    
            Send-CsvMessage -Level "Info" -Message "Sending email to $($global:SmtpTo) via $($global:SmtpServer):$($global:SmtpPort)"

            Send-MailMessage `
                -From $global:SmtpTo `
                -SmtpServer $global:SmtpServer `
                -Port $global:SmtpPort `
                -Credential $creds `
                -To $global:SmtpTo `
                -Subject "$($Script:SourceServer) - SQL Backup Move - Report" `
                -body $body `
                -UseSsl   
        }

    } else {
        $PingDMSQL03 = Test-Ping -HostName "DM-SQL03"
        $global:EmailMessage += Send-CsvMessage -Level "Info" -Message "Ping Status for DM-SQL03: $($PingDMSQL03)" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)

        $PingDMDA = Test-Ping -HostName "DM-DA"
        $global:EmailMessage += Send-CsvMessage -Level "Info" -Message "Ping Status for DM-DA: $($PingDMDA)" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
        # Unable to access either of the directories.  Send a email notice about this issue.
        $creds = Get-ConfigCredentials -Config ".\config.json"
    
        $body = Convert-ArrayToString -Array $Global:EmailMessage -AppendValue "`r`n"

        Send-CsvMessage -Level "Info" -Message "Sending email to $($global:SmtpTo) via $($global:SmtpServer):$($global:SmtpPort)"

        Send-MailMessage `
            -From $global:SmtpTo `
            -SmtpServer $global:SmtpServer `
            -Port $global:SmtpPort `
            -Credential $creds `
            -To $global:SmtpTo `
            -Subject "$($Script:SourceServer) SQL Backup Move - Error" `
            -body $body `
            -UseSsl
    }

    #TODO IF fail to open source and dest send email
    [int] $SleepTimer = 60 * $Script:SleepTimerMinutes
    Write-Host "Process is going to sleep for $Script:SleepTimerMinutes minutes."
    Start-Sleep -Seconds $SleepTimer

}