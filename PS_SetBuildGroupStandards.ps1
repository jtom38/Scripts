#
# PS_SetBuildGroupStandards.ps1
#

$_GroupType = "_SEC"
$_GroupApp = "_SHARED_"
$_GroupDepartmentsNew = @("Accounting", "Administration", "AdminServices", "ChildDevelopment", "Communications", "CommunityService", "Development", "Executive", "HousingPlanning", "HR", "IT", "Karluk", "ProgramDirectors", "Purchasing", "Weatherization", "CDC", "PAT", "RM")

$_counter = 0

$_ExportFile = "C:\Users\UserName\Desktop\PS_CopyUsersToNewGroup_Errors.csv"

foreach ($_GroupDepartmentsNew in $_GroupDepartmentsNew)
{
	$_varRW = $_GroupType + $_GroupApp + $_GroupDepartmentsNew + "_RW"
	$_varRO = $_GroupType + $_GroupApp + $_GroupDepartmentsNew + "_RO"

	try
	{
		New-ADGroup -Name $_varRW -DisplayName $_varRW -GroupScope Global -Path "OU=Security Groups,OU=Anchorage Office,OU=Ruralcap,DC=ruralcap,DC=lan"
		Write-Output "Group $_varRW was made."
	}
	catch
	{
		Write-Output "Error making group $_varRW.  Chances are it already exists."

		$_FileFound = Test-Path $_ExportFileBuildGroups
		if ($_FileFound = "TRUE")
		{
			#$_ErrorReport | Export-Csv $_ExportFileBuildGroups -Append
			$error[0].ToString() + $error[0].InvocationInfo.Line | Export-Csv $_ExportFile -Append
		}
		if ($_FileFound = "FALSE")
		{
			$error[0].ToString() + $error[0].InvocationInfo.Line | Export-Csv $_ExportFile
			#$_ErrorReport | Export-Csv $_ExportFileBuildGroups
		}
	}
		
	try
	{
		New-ADGroup -Name $_varRO -DisplayName $_varRO -GroupScope Global -Path "OU=Security Groups,OU=Anchorage Office,OU=Ruralcap,DC=ruralcap,DC=lan"
		Write-Output "Group $_varRO was made."
	}
	catch
	{
		Write-Output "Error making group $_varRO.  Chances are it already exists."
		$_ErrorReport = $_varRO

		$_FileFound = Test-Path $_ExportFileBuildGroups
		if ($_FileFound = "TRUE")
		{
			#$_ErrorReport | Export-Csv $_ExportFileBuildGroups -Append
			$error[0].ToString() + $error[0].InvocationInfo.Line | Export-Csv $_ExportFile -Append
		}
		if ($_FileFound = "FALSE")
		{
			#$_ErrorReport | Export-Csv $_ExportFileBuildGroups
			$error[0].ToString() + $error[0].InvocationInfo.Line | Export-Csv $_ExportFile
		}
	}
}

if ($_ErrorReport.Length -ge 1)
{
	Write-Output "Please review the file located at $_ExportFile to see what errored."
	Invoke-Item $_ExportFile
}