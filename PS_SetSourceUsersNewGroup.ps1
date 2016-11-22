#
# PS_SetSourceUsersNewGroup.ps1
#

$_GroupDepartmentsOld = @("Accounting", "AdministrationDept", "Admin Services", "ChildDevelopment", "Communications", "CommunityService", "Development", "Executive", "Housing and Planning", "HR", "Information Technology", "Karluk", "Program Directors", "Purchasing", "Weatherization", "#ChildDevRural")

#SEC = Security
#DST = Distro
$_GroupType = "_SEC"

#SP= Sharepoint
#SHARED=File Shares
$_GroupApp = "_SHARED_"

#RW = Read Write
#RO = Read Only
$_GroupPermission = "_RW"
$_GroupDepartmentsNew = @("Accounting", "Administration", "AdminServices", "ChildDevelopment", "Communications", "CommunityService", "Development", "Executive", "HousingPlanning", "HR", "IT", "Karluk", "ProgramDirectors", "Purchasing", "Weatherization", "RM", "CDC", "PAT")

$CSVData = @()
$_ExportFile = "C:\Users\userName\Desktop\PS_SetCopyUsersSourceToDestination_Logs.csv"

$_t = Test-Path $_ExportFile
if($_t = "TRUE")
{
	try
	{
		#Remove the item if its found without notification of action
		Remove-Item $_ExportFile -Confirm $true
	}
	catch
	{
		#dont write a output, its not needed.
	}
}

#Building a public counter ahead of time
$_Counter = 0

#Going to loop though all the values one at a time from the SOURCE department names
foreach ($_GroupDepartmentsOld in $_GroupDepartmentsOld)
{
	#Build a new string variable that has the new group name
	#Counter is needed here given it will change each time we loop though the old departments
	$_DestGroup = $_GroupType + $_GroupApp + $_GroupDepartmentsNew[$_Counter] + $_GroupPermission

	#Add one to our counter position
	$_Counter = $_Counter + 1

	#Write-Output $_DestGroup

	Write-Output "Please wait, getting users from $_GroupDepartmentsOld. `n"

	#Request all the usernames from the SOURCE group we are on currently in the loop
	$_UsersFromSource = Get-ADGroupMember $_GroupDepartmentsOld | select SamAccountName

	#Get the number of users found in the group
	$_NumInSource = 0
	$_NumInSource = $_UsersFromSource.length
	Write-Output "Found a total of $_NumInSource users in the group $_GroupDepartmentsOld. `n"	

	#This is needed to process all the users from the old group to put them in the new one
	foreach ($_UsersFromSource in $_UsersFromSource)
	{
		#Remove extra data on the string
		$_UserName = $_UsersFromSource
		$_UserName = $_UserName -replace "@{SamAccountName=", ""
		$_UserName = $_UserName -replace "}", ""

		try
		{
			#Add the username after we trimmed the value that we pulled from the group
			Add-ADGroupMember -Identity $_DestGroup -Members $_UserName
			Write-Output "User $_UserName ADDED to $_DestGroup"

			#Add the current action to the csv data to be exported later.
			$row = New-Object System.Object
			$row | Add-Member -MemberType NoteProperty -Name SourceGroup -Value $_GroupDepartmentsOld
			$row | Add-Member -MemberType NoteProperty -Name DestinationGroup -Value $_DestGroup
			$row | Add-Member -MemberType NoteProperty -Name UserName -Value $_UserName
			$CSVData += $row

		}
		catch
		{

		}
	}
}

	#Export the log
	$CSVData | Export-Csv $_ExportFile