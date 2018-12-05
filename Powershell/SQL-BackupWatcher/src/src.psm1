
$root = @( Get-ChildItem -Path $PSScriptRoot\*.ps1 -ErrorAction SilentlyContinue)
Write-Debug -Message "Looking for all files in Public"
$Directory =  @( Get-ChildItem -Path $PSScriptRoot\Directory\*.ps1 -ErrorAction SilentlyContinue)

Write-Debug -Message "Looking for all files in Private"
$File = @( Get-ChildItem -Path $PSScriptRoot\File\*.ps1 -ErrorAction SilentlyContinue)
$Smtp = @( Get-ChildItem -Path $PSScriptRoot\Smtp\*.ps1 -ErrorAction SilentlyContinue)


foreach($import in @($Public + $Private)){

    try{
        . $import.fullname
    }catch{
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename
