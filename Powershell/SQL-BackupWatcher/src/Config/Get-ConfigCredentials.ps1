
function Get-ConfigCredentials {
    param (
        [string] $Config
    )
    
    Process { 
        
        $json = Get-Content $Config | ConvertFrom-Json

        $creds = [pscredential]::new($json.Smtp.Credentials.UserName, $($json.Smtp.Credentials.Password | ConvertTo-SecureString))

        return $creds
    }
}