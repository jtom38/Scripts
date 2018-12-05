
function Get-RemotePath {
    param (
        [string] $DirectoryPath,
        [string] $FilePath
    )
    
    Process{
        $path = ""

        if( [System.String]::IsNullOrEmpty($DirectoryPath) -eq $false ){
            # We got a value
            $DirInfo = [System.IO.DirectoryInfo]::new($DirectoryPath)
            
        }
        if( [System.String]::IsNullOrEmpty($FilePath) -eq $false ){
            $FileInfo = [System.IO.FileInfo]::new($FilePath)
            
        }

        # Get the Directory structure that we will need to check for on the remote server
        $SourcePath = $FileInfo.DirectoryName
        $SourcePath = $SourcePath.Replace($script:SourceDirectory, "")

        # Translate our path to the remote servers path
        $remotepath = "$script:DestinationDirectory$SourcePath"

        return $remotepath
    }

}
