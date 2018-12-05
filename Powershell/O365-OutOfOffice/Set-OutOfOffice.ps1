

Write-host "Please enter your Office 365 GA account to connect to 365."
$O365Creds = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
    -ConnectionUri https://outlook.office365.com/powershell-liveid/ `
    -Credential $O365Creds `
    -Authentication Basic `
    -AllowRedirection

# Import the session 
Import-PSSession $Session -DisableNameChecking

$CommandCheck = Get-Command -Name Get-MailboxAutoReplyConfiguration
$CommandCheckCount = $CommandCheck | Measure-Object

if ( $CommandCheckCount -eq 1 ) {
    #Session should be active
}

Write-Host "Enter the email address we are going to apply Out Of Office for."
$UserName = Read-Host

Write-Host "Enter the External Message to be set."
$External = Read-Host

Write-Host "Enter the Internal Message to be set."
$Internal = Read-Host

Write-Host "Setting values to $($UserName)"
Set-MailboxAutoReplyConfiguration -Identity $UserName `
    -AutoReplyState Enabled `
    -ExternalMessage $External `
    -InternalMessage $Internal

# Disconnects
Write-Host "Closing the session."
Remove-PSSession $Session