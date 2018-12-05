
function Search-BackupHold {
    param (
        [string] $FileDir,
        [int] $FileCount
    )
    
    Process {



        if ( $FileDir.Contains("\LOG") -eq $true -and
             $FileCount -ge $script:LogBackupHold -eq $true) {
                return $true
        }

        if ( $FileDir.Contains("\FULL") -eq $true -and
             $FileCount -ge $script:FullBackupHold -eq $true ) {
                return $true
        }

        if ( $FileDir.Contains("\DIFF") -eq $true -and
            $FileCount -ge $script:DiffBackupHold -eq $true ) {
                return $true
        }

        # if we made it this far, we got nothing to do
        return $false
    }
}