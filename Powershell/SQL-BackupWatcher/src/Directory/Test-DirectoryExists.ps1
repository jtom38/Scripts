
function Test-DirectoryExists {
    param (
        [string] $Path
    )
    
    Process {

        $dest = Test-Path -Path $Path
        if( $dest -eq $false ) {
            $global:EmailMessage += Send-CsvMessage -Message "Unable to access $Path" -Level "Error" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
            return $false
        } else {
            $global:EmailMessage += Send-CsvMessage -Message "Able to access $Path" -Level "Info" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
            return $true
        }
        
    }
}