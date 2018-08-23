
# Enable calls for CSV writes
. .\Modules\Logger-CSV.ps1

# Enable calls for EventViewer
. .\Modules\Logger-EventViewer.ps1

# Enable calls for Smtp
. .\Modules\Logger-Smtp.ps1

function Set-LogInfo{

    [CmdletBinding()]

    Param(
        [Parameter(Mandatory=$true)][string] $Message,
        [Parameter(Mandatory=$false)][int] $LineNumber,
        [Parameter(Mandatory=$false)][string] $CallingFile
    )

    Process{
        # Check settings file for config
        $settings = Get-Content -Path .\Logger-Config.json | ConvertFrom-Json

        # Check to see who is enabled for this message type.
        
        Set-CsvMessage -Level "Info" -Message $Message -LineNumber $LineNumber -CallingFile $CallingFile
        #$msg = Generate-Message -Type "Info" -Message $Message -MessageFormat $settings.LogFormat

    }
}

function Set-LogDebug {
    <#
    .SYNOPSIS
        Sends a SYSLOG message to a server running the SYSLOG daemon
    .DESCRIPTION
        Sends a message to a SYSLOG server as defined in RFC 5424. A SYSLOG message contains not only raw message text,
        but also a severity level and application/system within the host that has generated the message.
    .PARAMETER Message
        Value from the message
    .Example
        Set-LogDebug -Message "Test Message"
    #>
    param (
        [Parameter(Mandatory=$true)][string] $Message
    )
    
    Process{
        # Check settings file for config
        $settings = Get-Content -Path .\Logger-Config.json | ConvertFrom-Json

        $msg = Generate-Message -Type "Debug" -Message $Message -MessageFormat $settings.LogFormat

        # Need to check to see what we have for enabled outputs

        Add-Content -Path $settings.PathLogName -Value
    }
}

function Check-Loggers{
    Process{
        $settings = Get-Content -Path .\Logger-Config.json | ConvertFrom-Json

        if($settings.CsvEnabled -eq 1){

        }
    }
}

function Get-CurrentLineNumber { 
    return $MyInvocation.ScriptLineNumber
}

function Get-CurrentFileName { 
    $info = [System.IO.FileInfo]::new($MyInvocation.ScriptName)
    return $info.Name
}

