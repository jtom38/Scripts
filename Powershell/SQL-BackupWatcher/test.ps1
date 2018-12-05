
Import-Module .\PsLogCsv\PsLogCsv.psm1 -Force
Set-CsvConfig -Config ".\config.json"

. .\src\Config\Import-Settings.ps1
Import-Settings -Config ".\config.json"

$Global:EmailMessage = @()
$Global:EmailMessage += Send-CsvMessage -Message "dev test" -Level "debug" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
$Global:EmailMessage += Send-CsvMessage -Message "dev test" -Level "debug" -CallingFile $(Get-CurrentFileName) -LineNumber $(Get-CurrentLineNumber)
#Import-Module .\PsSmtpHelper\PsSmtpHelper.psm1 -Force

. .\src\Config\Set-ConfigCredentials.ps1
#Set-ConfigCredentials -Config ".\config.json"

. .\src\Config\Get-ConfigCredentials.ps1
$creds = Get-ConfigCredentials -Config ".\config.json"

. .\src\Convert-ArrayToString.ps1
$body = Convert-ArrayToString -Array $Global:EmailMessage -JoinValue "`r`n"

Send-MailMessage `
    -From $global:SmtpTo `
    -SmtpServer $global:SmtpServer `
    -Port $global:SmtpPort `
    -Credential $creds `
    -To $global:SmtpTo `
    -Subject "Debug email test" `
    -body $body `
    -UseSsl

Write-Host $"$($msg1.Attachments[0]) $($msg1.Body[0])"
