#
# PS_GetOldComputers.ps1
#
#change the date range if you want.  Pulls anything older then currently 90 days of today.

$_ExportFile = "C:\Users\userName\Desktop\PS_ListOfOldComputers.csv"

$_DateCutoff = (Get-Date).AddDays(-90)

$_OldComputers = Get-ADComputer -Filter {LastLogonDate -le $_DateCutoff} -Properties LastLogonDate, enabled | Select Name, LastLogonDate, Enabled

<#
Code use to auto disable accounts.	
foreach ($_OldComputers in $_OldComputers)
{
		$_SingleComputer = $_OldComputers | select name
		$_SingleComputer = $_SingleComputer -replace "@{Name=", ""
		$_SingleComputer = $_SingleComputer -replace "}", ""
		Set-ADComputer -Identity $_SingleComputer -Enabled $false

} 
#>

$_var = Test-Path = $_ExportFile

if ($_var = "TRUE")
{
	Remove-Item $_ExportFile -Confirm $True
}

$_OldComputers | Export-Csv $_ExportFile
Invoke-Item $_ExportFile