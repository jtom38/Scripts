# Refrence
# sdelete - https://docs.microsoft.com/en-us/sysinternals/downloads/sdelete
# Install-AutoCleanTask.ps1
#   Used to install the required Scheduled Task
# Start-AutoClean.ps1
#   Task to clean up the TempFolder

# This file is used to copy the required files to the users profile for later use.

$DebugMode = $false

# Dependancies
$PathLocalInstall = [System.Text.StringBuilder]::new()
$PathLocalInstall.Append($env:USERPROFILE).Append("\AppData\Local\AutoClean\")
$PathRepo = $null
if($DebugMode -eq $true){
    $PathRepo = "\\directorsmortgage.net\SYSVOL\directorsmortgage.net\scripts\AutoClean\dev\"
}else {
    $PathRepo = "\\directorsmortgage.net\SYSVOL\directorsmortgage.net\scripts\AutoClean\"    
}

# Checking the expected folder for anything
if([System.IO.Directory]::Exists($PathLocalInstall) -eq $false){
    # Generate the Directory
    [System.IO.Directory]::CreateDirectory($PathLocalInstall)
}

$ConnectionResult = Test-Path -Path $PathRepo

# Check for Files on the server
if ( $ConnectionResult -eq $true){
    # Pull down a fresh copy of the files.
    $LocalFiles = [System.IO.Directory]::GetFiles($PathLocalInstall)
    foreach($file in $LocalFiles){
        [System.IO.File]::Delete($file)
    }

    # Get files on server.
    $Files = [System.IO.Directory]::GetFiles($PathRepo)

    # Update each File to make sure we are current
    foreach($file in $Files){
        # Get the FileInfo
        $FileRemoteInfo = [System.IO.FileInfo]::new($file)

        # Build the Local path for this file.
        $FileLocal = [System.Text.StringBuilder]::new()
        $FileLocal.Append($PathLocalInstall).Append($FileRemoteInfo.Name)

        # Build the remote path for this file.
        $FileRemote = [System.Text.StringBuilder]::new()
        $FileRemote.Append($PathRepo).Append($FileRemoteInfo.Name)

        [System.IO.File]::Copy($FileRemote, $FileLocal, $true)    
    }
}

Set-Location -Path $PathLocalInstall
# Install the Scheduled Task to run as the user

.\Install-AutoCleanTask.ps1
.\Start-AutoClean.ps1