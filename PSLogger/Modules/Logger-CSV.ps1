
. .\Modules\Logger-MessageFormat.ps1

function Set-CsvMessage {
    param (
        [Parameter(Mandatory=$true)][string] $Level,
        [Parameter(Mandatory=$true)][string] $Message,
        [Parameter(Mandatory=$false)][int] $LineNumber,
        [Parameter(Mandatory=$false)][string] $CallingFile
    )
    Process{
        $settings = Get-Content -Path .\Logger-Config.json | ConvertFrom-Json
        [string] $PathFile = ""

        # Check Config to see if we process this Message
        [bool]$ProcessCsv = Get-CsvEnabled -Level $Level
        if($ProcessCsv -eq $false){
            return $false
        }

        # Format our message to the way it was requested
        $LogEntry = Get-MessageFormat -Level $Level -Message $Message

        # Confirm File Exists
        $wd = [System.IO.Directory]::GetCurrentDirectory()
        $PathFile = "{0}\{1}" -f $wd, $settings.CsvFileName

        if([System.IO.File]::Exists($PathFile) -eq $false){
            # File was not found, Generate a new file.
            New-Item -Path $wd -Name $settings.CsvFileName -ItemType "file"

            # Insert the header
            $header = Get-CsvHeader
            Add-Content -Path $PathFile -Value $header
        }
        # Do we archive?  This need to be figured out and built

        # Write the message
        Add-Content -Path $PathFile -Value $LogEntry

    }
}
function Get-CsvEnabled {
    param (
        [Parameter(Mandatory=$true)][string] $Level
    )  
    Process{
        
        if($settings.CsvEnabled -eq 1){
            # CSV is Enabled
            foreach($t in $settings.CsvLevels){

                # Check to see if the Level we have matches to what is request for CSV Logs.
                If($t -eq $Level){
                    # Found our mark. Pass this over to processed.
                    return $true
                } 
            }

            # If we did not find our mark by this point do not use this output
            return $false
        }
    }
}

function Get-MessageFormat {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string] $Level,
        [Parameter(Mandatory=$true)][string] $Message
    )
    
    Process{
        # Read Config file for CsvLogFormat
        $settings = Get-Content -Path .\Logger-Config.json | ConvertFrom-Json

        $msg = Convert-LogFormat -Level $Level -Message $Message -LogFormat $settings.CsvLogFormat

        return $msg
    }
}

function Get-CsvHeader {   
    Process{
        $settings = Get-Content -Path .\Logger-Config.json | ConvertFrom-Json
        $s = $settings.CsvLogFormat

        if( $s.Contains("#Level#") -eq $true ){
            $s = $s.Replace("#Level#", "Level")
        }

        if( $s.Contains("#DateTime#") -eq $true ){
            $dt = [System.DateTime]::Now
            $s = $s.Replace("#DateTime#", "DateTime")
        }

        if( $s.Contains("#Message#") -eq $true ){
            $s = $s.Replace("#Message#", "Message")
        }

        if( $s.Contains("#LineNumber#") -eq $true){
            $s = $s.Replace("#LineNumber#", "LineNumber")
        }

        if( $s.Contains("#File#") -eq $true){
            $s = $s.Replace("#File#", "File")
        }

        return $s
    }
}
