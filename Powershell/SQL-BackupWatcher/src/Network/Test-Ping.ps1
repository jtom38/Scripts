
function Test-Ping {
    param (
        # Enter the HostName or IP Address to test against.
        [string] $HostName
    )
    
    Process {
        $Ping = [System.Net.NetworkInformation.Ping]::new()
        $PingResult = $ping.Send($HostName)
        if ( $PingResult.Status -eq "Success" ) {
            return $true
        } else {
            return $false
        }
    }
}