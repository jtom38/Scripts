

Write-host "Please enter your Office 365 GA account to connect to 365."
$O365Creds = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
    -Credential $O365Creds `
    -Authentication Basic `
    -AllowRedirection

# Import the session 
Import-PSSession $Session -DisableNameChecking

$CommandCheck = Get-Command -Name Set-MailboxAutoReplyConfiguration
$CommandCheckCount = $CommandCheck | Measure-Object

if ( $CommandCheckCount -eq 1 ) {
    #Session should be active
}

Write-Host "Enter the email address we are going to apply Out Of Office for."
$UserName = Read-Host

Set-MailboxAutoReplyConfiguration -Identity $UserName `
    -AutoReplyState Disabled

# Disconnects
Remove-PSSession $Session