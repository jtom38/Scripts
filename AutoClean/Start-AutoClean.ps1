
# Set script Location
$UserName = $env:USERNAME

# Get the path from the executing script location
$PathScript = Split-Path -Parent $PSCommandPath

#64 or 32bit OS
$OSType = [Environment]::Is64BitOperatingSystem

# Check for Dependancies
If( [System.IO.File]::Exists("$PathScript\sdelete.exe") -eq $false){
    Write-Host "Unable to find sdelete.exe"
    exit
}

if( [System.IO.File]::Exists("$PathScript\sdelete64.exe") -eq $false){
    Write-Host "Unable to find sdelete64.exe"
    exit
}

# Focus on the users Temp Folder
#$PathTemp = [System.Text.StringBuilder]::new()
#$PathTemp.Append("C:\Users\").Append([System.Environment]::UserName).Append("\AppData\Local\Temp\")

# Read the Json file
#$json = Get-Content -Path ".\folders.json" | ConvertFrom-Json

$PathTemp = $env:TEMP

$Folders = [System.IO.Directory]::GetDirectories($PathTemp)

# Purge the temp folder
foreach($item in $folders){
    if( $OSType = $true ){
        # Use the 64bit file.
        try{
            $null = .\sdelete64.exe -r -s -q "$item" /accepteula
        } catch {
            [System.Console]::WriteLine("[Error] $item")
        }       
    }else {
        # Use the 32bit file.
        try{
            $null = .\sdelete64.exe -r -s -q "$item" /accepteula
        } catch {
            [System.Console]::WriteLine("[Error] $item")
        } 
    }
}

# Remove any old files at the root directory
$Files = [System.IO.Directory]::GetFiles($PathTemp)
foreach($item in $Files){
    if( $OSType = $true ){
        # Use the 64bit file.
        try{
            $null = .\sdelete64.exe -r -s -q "$item" /accepteula
        } catch {
            [System.Console]::WriteLine("[Error] $item")
        }       
    }else {
        # Use the 32bit file.
        try{
            $null = .\sdelete64.exe -r -s -q "$item" /accepteula
        } catch {
            [System.Console]::WriteLine("[Error] $item")
        } 
    }
}