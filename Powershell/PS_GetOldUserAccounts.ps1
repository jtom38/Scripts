#
# PS_GetOldUserAccounts.ps1
#

$_ExportFile = "C:\Users\userName\Desktop\PS_ListOfOldUsers.csv"
$_DateCutoff = (Get-Date).AddDays(-90)

$_OldUserAccounts = Get-ADUser -Filter {LastLogonDate -le $_DateCutoff} -Properties LastLogonDate, Enabled, DistinguishedName | select Name, SamAccountName, LastLogonDate, Enabled, DistinguishedName
#$_OldUserAccounts = Get-ADUser -Filter {LastLogonDate -le $_DateCutoff} -Properties * 


<#
#Code use to auto disable accounts.	
foreach ($_OldUserAccounts in $_OldUserAccounts)
{
	$_SingleUser = $_OldUserAccounts | select SamAccountName
	$_SingleUser = $_SingleUser -replace "@{SamAccountName=", ""
	$_SingleUser = $_SingleUser -replace "}", ""
	Set-ADUser -Identity $_SingleUser -Enabled $false
} 
#>

$_var = Test-Path = $_ExportFile

if ($_var = "TRUE")
{
	Remove-Item $_ExportFile -Confirm $True
}

$_OldUserAccounts | Export-Csv $_ExportFile
Invoke-Item $_ExportFile