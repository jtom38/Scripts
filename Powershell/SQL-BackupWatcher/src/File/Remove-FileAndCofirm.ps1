
function Remove-FileAndCofirm {
    param (
        [string] $File
    )

    Process {
        # Lets confirm that we do not have an existing filename.  That would be bad.

        # We have the oldest file by CreationTime, Remove it
        [System.IO.File]::Delete($File)

        # Confirm File was removed
        if( [System.IO.File]::Exists($File) -eq $false ){
            # Confirmed, File was removed
        } else {
            # File was not removed.  WTF to do with this.                        
        }
    }  
}