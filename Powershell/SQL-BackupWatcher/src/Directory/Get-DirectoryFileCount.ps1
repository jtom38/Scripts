
function Get-DirectoryFileCount {
    param (
        [string] $DirectoryPath
    )
    
    Process{
        $m = [System.IO.Directory]::GetFiles($DirectoryPath)
        return $m.Length
    }
}