
function Copy-ToDirectory {
    param (
        [string] $File,
        [string] $RemotePath,
        [bool] $RemoveSource
    )
    
    Process {
        if( [System.IO.File]::Exists($File) -eq $false){
            # We have a problem.  This file should not be here.
            return
        }

        # Generate the FileInfo on the source file
        $FileInfo = [System.IO.FileInfo]::new($File)

        # Get the File Name for later
        $FileName = $FileInfo.Name

        # Get the Size of the file.
        $FileSize = $FileInfo.Length

        # Take the remotePath and FileName to generate the new full path
        $RemoteFile = "$RemotePath\$FileName"

        # Copy the file over to the new server now.
        [System.IO.File]::Copy($File, $RemoteFile)

        # Confirm that the file was moved over.
        if( [System.IO.File]::Exists($RemoteFile) -eq $true){
            # We have confimed the file was moved.
            $RemoteFileInfo = [System.IO.FileInfo]::new($RemoteFile)

            # Get the File Size of the file we just copied
            $RemoteFileLength = $RemoteFileInfo.Length

            # Check to see if they match the same size.
            $FileSizeSame = $RemoteFileLength -eq $FileSize
            if( $FileSizeSame -eq $false ){
                # And... problem.
                $global:EmailMessage += Send-CsvMessage -Level "Error" -Message "The file that was copied '$RemoteFile' does not result in the same length as $File." -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)        
            } else {
                $global:EmailMessage += Send-CsvMessage -Level "Info" -Message "The file that was copied '$RemoteFile' has the same exact size as the source file." -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
            }

            # Check to see if we can delete the source file and confirm we did not have any problems.
            if( $RemoveSource -eq $true -and
                $FileSizeSame -eq $true){
                # Check to make sure we are good to delete the source file.
                [System.IO.File]::Delete($File)
                $global:EmailMessage += Send-CsvMessage -Level "Info" -Message "File Deleted: $File" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
            }

            return $true
        } else {
            # RemoteFile did not get copied over
            # Test the path again to the server
            Send-CsvMessage -Level "Error" -Message "Copy job failed.  Going to run though tests to see why."
            $RemotePathExists = [System.IO.Directory]::Exists($RemotePath)
            if( $RemotePathExists -eq $false ) {
                Send-CsvMessage -Level "Error" -Message "Directory not found: $RemotePath" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
            }

            $FileExists = [System.IO.File]::Exists($File)
            if( $FileExists -eq $false) {
                Send-CsvMessage -Level "Error" -Message "File not found: $File" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
            }

            return $false
        }
    }
}