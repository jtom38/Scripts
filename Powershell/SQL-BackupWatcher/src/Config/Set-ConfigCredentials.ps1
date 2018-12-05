

function Set-ConfigCredentials {
    param (
        [string] $Config
    )
    
    Process {

        # Get the creds 
        $Creds = Get-Credential

        # Convert it to text
        $SecurePWAsText = $Creds.Password | ConvertFrom-SecureString

        # Read the Json File
        $json = Get-Content -Path $Config | ConvertFrom-Json

        # Update the json in memory
        $json.Smtp.Credentials.UserName = $Creds.UserName
        $json.Smtp.Credentials.Password = $SecurePWAsText
        $json.Smtp.Credentials.GeneratedBy = $Env:USERNAME

        # Write the changes to the config
        $json | ConvertTo-Json | Set-Content $Config

    }
}