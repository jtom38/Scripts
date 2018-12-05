Write-host "Please enter your Office 365 GA account to connect to 365."
$O365Creds = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
    -Credential $O365Creds `
    -Authentication Basic `
    -AllowRedirection

# Import the session 
Import-PSSession $Session -DisableNameChecking

# What account gets access to SendAs
Write-Host "Please enter the name of the account that we will grant SendAs for every account."
$Trustee = Read-Host

# Get the list of all the users
$UserAccounts = Get-Mailbox | select identity

#Add-RecipientPermission UserAccount -AccessRights SendAs -Trustee "billy bob"

foreach ( $u in $UserAccounts ) {
    try {
        Add-RecipientPermission $u.Identity -AccessRights SendAs -Trustee "svc EmailAuto" -Confirm:$false
    }
    catch {
        Write-Host "Failed to add: $u"
    }
    
}

# Disconnects
Write-Host "Closing the session."
Remove-PSSession $Session