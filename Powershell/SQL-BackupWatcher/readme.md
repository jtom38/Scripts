# PsBackupMove

## Description

Small script that can be used to move files to new homes.

## Logic Flow

### Start-FileMove.ps1

    1. Import-Settings
        Chceks for a config.json file and imports all the values into $script: vars to be used later.
    2. Checks the SourceDirectory and DesitinationDirectory to make sure it can access them correctly.
        If Failure, send email notice about failure to connect.
    3. Loop Starts
    4. Gets all the directories from SourceDirectory
        Should contain the DatabaseName
    5. Checks the database folder for the type of backups.
        FULL
        DIFF
        LOG
    6. Opens one of the sub directories
        root\DatabaseName\BackupType
    7. Gets all the files in that directory
    8. Checks to make sure the directory exists on the remote server
    9. Gets the number of files on the remote server
    10. If we have more files in the remote directory then we allow it will find the oldest file and delete it.
    11. If the directory contains the number of files alloud or greater, looks for the oldest file and deletes it.
    12. Copies the new file to the remote server and confirms the file exists and also checks the bytes in the file.
    13. Once it has finished its loop though all the directories we check to see if we moved a file
    14. If we moved a file we will send a email off with the current transation log of what we did.
    15. Script goes to sleep for the defined amount of time in the config.json

### Set-SmtpCrednetials.ps1

This is a helper script to make it easy to update the SMTP creds that are used for the script.  Remember when you run this make sure you run this as the user who runs the script!  PowerShell uses Windows Data Protection API for this function to export a secure string.  TL;DR only the user who exports the securestring will be able to reverse the encryption and use it.  This is VERY important to remember.

## Config File

[string] SourceDirectory = Path to monitor
[string] DestinationDirectory = Path to place files found
[int] FullBackupHold = Defines the number of FULL backups to keep on hand. We will remove the oldest file if we go over our limit.
[int] DiffBackupHold = Defines the number of DIFF backups to keep on hand. We will remove the oldest file if we go over our limit.
[int] LogBackupHold = Defines the number of LOG Backups to keep on ahdn.  We Will remove the oldest file if we go over our limit.
[string] IsDupeFile = Used to determin how to handle if a dupe file is found
    Values
        Delete = Deletes the file on the Destination and places a new copy.
        Ignore = Deletes the file on the Source and moves on.
        Rename = Renames the Dest file so we can add the new file.
[int] SleepTimerMinutes = Defines how long the script will go to sleep once it has finished its checks

## Permissions

The account running this process needs to have Read/Write permissions to both servers.