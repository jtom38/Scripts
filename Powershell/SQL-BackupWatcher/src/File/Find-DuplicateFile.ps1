
function Find-DuplicateFile {
    param (
        [string] $Source,
        [string] $Destination
    )
    
    Process {
        # Check to see if the Destination File exists, dur
        if( [System.IO.File]::Exists($Destination) -eq $false ) {
            return $false
        } 
        
        # We have a dupe

        # Check the length to see if they match.
        # We could have two different files with the same name. This should be managed by the Config

        # Check the config for what we need to do.
        if ( $Script:IsDupeFile.Equals("Delete")){
            # Delete the file on Destination
            [System.IO.File]::Delete($Destination)
        }

        if ( $Script:IsDupeFile.Equals("Ingore")) {
            # Do nothing
        }

        if ( $Script:IsDupeFile.Equals("Rename")) {
            $info = [System.IO.FileInfo]::new($Destination)

            # Get the FileName
            $NewName = $info.Name

            # Ajust it to something new 
            $NewName = $NewName.Insert($NewName.Length - 4, "dupe")

            # Build the new path
            $dir = $info.Directory
            $NewPath = "$dir\$NewName"

            $info = $info.CopyTo($NewPath)
        }
    }
}