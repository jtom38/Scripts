function Find-OldestFile {
    param (
        [string] $DirectoryPath
    )
    
    Process{
        # Convert the string to lowercase to ease this
        $FilesFound = [System.IO.Directory]::GetFiles($DirectoryPath)

        #[Collections.Generic.List[datetime]] $DateCreated = @()
        [datetime[]] $DateCreated = @()
        # Loop though all the files and get the DateCreated

        foreach($file in $FilesFound){
            # Get the FileInfo from the file so we can get the Date Created
            $f = [System.IO.FileInfo]::new($file)
            # get the value from the file
            $DateCreated += $f.CreationTime
            #$DateCreated.Add($f.CreationTime)
        }
        
        #Find the oldest value
        $min = $DateCreated | Measure-Object -Minimum
        $MinValue = $min.Minimum

        $global:EmailMessage += Send-CsvMessage -Message "Oldest file in $($DirectoryPath) was created on $($MinValue)." -Level "Info" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)

        # We have our min.  Lets find this file
        foreach($file in $FilesFound){
            $f = [System.IO.FileInfo]::new($file)

            if( $f.CreationTime -eq $MinValue ){
                # Found our value.  Return the file path
                return $file
            }
        }
    }
}