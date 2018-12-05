
# https://www.pdq.com/blog/secure-password-with-powershell-encrypting-credentials-part-1/

Write-Host "Welcome to Update-SmtpCredentials.ps1"
Write-Host "This is a helper script to update the config file with new Credentials so that we can use them to send an email."
Write-Host "Please remember, The user account that runs this process will be the only one who can decrypt the string."
Write-Host ""
Write-Host "Script is being ran as $($env:USERDOMAIN)"

# Get the creds
Write-Host "Please enter the email address and password for the account you want to use."
$Creds = Get-Credential

# Convert it to text
$SecurePWAsText = $Creds.Password | ConvertFrom-SecureString

Write-Host "Enter the location of the config.json file."
Write-Host "If you leave this empty I will check '.\config.json'"

# Get User input
$Config = Read-Host 

if ( [System.IO.File]::Exists($Config) -eq $false ) {
    Write-Host "File $($Config) was not found.  Create it?
    0 = no
    1 = yes
    You will need to populate the rest of the config settings."

    $r = Read-Host
    if ( $r -eq 1 ) {
        New-item -Path $Config -ItemType File -
    }
} 

# Read the Json File
$json = Get-Content -Path $Config | ConvertFrom-Json

# Update the json in memory
$json.Smtp.Credentials.UserName = $Creds.UserName
$json.Smtp.Credentials.Password = $SecurePWAsText
$json.Smtp.Credentials.GeneratedBy = $Env:USERNAME

# Write the changes to the config
$json | ConvertTo-Json | Set-Content $Config