#
# PS_GetAllocationList.ps1
#
$_groups = @("_SEC_SHARED_Accounting_RW", "_SEC_SHARED_Administration_RW", "_SEC_SHARED_AdminServices_RW", "_SEC_SHARED_ChildDevelopment_RW", "_SEC_SHARED_Communications_RW", "_SEC_SHARED_CommunityService_RW", "_SEC_SHARED_Development_RW", "_SEC_SHARED_Executive_RW", "_SEC_SHARED_HousingPlanning_RW", "_SEC_SHARED_HR_RW", "_SEC_SHARED_IT_RW", "_SEC_SHARED_Karluk_RW", "_SEC_SHARED_ProgramDirectors_RW", "_SEC_SHARED_Purchasing_RW", "_SEC_SHARED_Weatherization_RW", "_SEC_SHARED_CDC_RW", "_SEC_SHARED_PAT_RW", "_SEC_SHARED_RM_RW", "_SEC_SHARED_PAT_RO", "#Supportive Housing", "#CDC Staff")

$_path = "C:\Users\userName\Desktop\Powershell\"

$_EmailServer = "emailServer"
$_EmailFrom = "PowerShellReports@domain.com"
$_EmailTo = "emailTo@domain.com"
#$_EmailCC = "emailCC@domain.com"
$_EmailBody = "See attached document. `n`nDo not reply to this email, it will fall into the void."


Function Get-RNG
{
	$rng1 = Get-Random -Minimum 1 -Maximum 9
	$rng2 = Get-Random -Minimum 1 -Maximum 9
	$rng3 = Get-Random -Minimum 1 -Maximum 9
	$rng4 = Get-Random -Minimum 1 -Maximum 9

	Write-Output $rng1$rng2$rng3$rng4
}

Function Get-Requirements
{
#Make sure that we have at least version 4.0 of powershell.  Thats what this script was built for.
$_ClientVersion = $PSVersionTable.PSVersion.Major
#$ClientVersion = $ClientVersion.ToString()

if ($_ClientVersion -eq "4")
{
   #all is good here, going to skip   
}
else
{
    #this wont generate a error so if it fails to be at least version 4 this will take effect.
    $output =
    "Please update powershell to at least version 4.0"
    "https://www.microsoft.com/en-us/download/details.aspx?id=40855"
    Write-Output $output
    exit
}

#Make sure that the AD tools are installed so we can pull our data
try
{
    Import-Module ActiveDirectory
}
catch
{
    $output =
    "Active Directory Module is missing.  Please install it for this to work."
    "Remote Server Administration Tools for Windows 7 with Service Pack 1 (SP1)"
    "https://www.microsoft.com/en-us/download/details.aspx?id=7887"
    write-Output $output
    exit
}
}

Function Get-UsersFromGroups
{
	#pull the users from the groups and store the data in a variable
	$CSVData = @()
	foreach ($_groups in $_groups)
	{
		Write-Output "Please Wait... Requesting user data from $_groups."

		#going to loop though all the groups and each time the loop runs we run a queury to see what usernames are in the requested group
		$_UsersFromGroup = Get-ADGroupMember $_groups | select SamAccountName
		
		#All this is doing is storing the number of users we found in the group
		$_NumberOfUsers = $_UsersFromGroup.length

		Write-Output "Found $_NumberOfUsers users in $_groups.`n"

		#take the stored list of names and run though each pulling info out as needed
		foreach( $_UsersFromGroup in $_UsersFromGroup)
		{
			#Remove extra data on the string
			$_UserName = $_UsersFromGroup
			$_UserName = $_UserName -replace "@{SamAccountName=", ""
			$_UserName = $_UserName -replace "}", ""

			try
			{
				#Request all the data on the username that we passed to it.
				# -Properties '*' gets ALL the data on the user account that we can pull in the data that we need
				$var = Get-ADUser $_UserName -Properties '*'
			}
			catch
			{
				Write-Output "Ran into a error trying to pull data for the user $_UserName!`n"
			}

			#This block builds a custom table so we can dump our data in.
			#CSVData is object that contains all the data not $row.  PS deals with this in a very strange way.
			$row = New-Object System.Object
			$row | Add-Member -MemberType NoteProperty -Name ADGroup -Value $_groups
			$row | Add-Member -MemberType NoteProperty -Name Department -Value $var.Department
			$row | Add-Member -MemberType NoteProperty -Name Name -Value $var.Name
			$row | Add-Member -MemberType NoteProperty -Name Type -Value $var.ObjectClass
			$row | Add-Member -MemberType NoteProperty -Name Description -Value $var.Description
			$row | Add-Member -MemberType NoteProperty -Name LastLogonDate -Value $var.LastLogonDate
            $row | Add-Member -MemberType NoteProperty -Name Enabled -Value $var.Enabled
			$CSVData += $row
		}
	}

	#Removes dupe data based on the values in the Name Column
	$CSVDataNoDupe = $CSVData | Sort-Object -Property "Name" -Unique

	#if you want the unfiltered version of the data so it contains duplicates comment out the one above and uncomment this one below
	#$CSVDataNoDupe = $CSVData | Sort-Object -Property "Name"
	#Sorts the data back to being based on Department

	$CSVDataNoDupe = $CSVDataNoDupe | Sort-Object -Property "Department"
	
	#figure out what he month is for the file name
	#Get-Date.Month returns a number value of the month.
	#We are going to take that value and save the written month value in a variable
	$date = Get-date	
	switch($date.Month)
	{
		1 {$_CurrentMonth = "Januaray"; break}
		2 {$_CurrentMonth = "February"; break}
		3 {$_CurrentMonth = "March"; break}
		4 {$_CurrentMonth = "April"; break}
		5 {$_CurrentMonth = "May"; break}
		6 {$_CurrentMonth = "June"; break}
		7 {$_CurrentMonth = "July"; break}
		8 {$_CurrentMonth = "August"; break}
		9 {$_CurrentMonth = "September"; break}
		10 {$_CurrentMonth = "October"; break}
		11 {$_CurrentMonth = "November"; break}
		12 {$_CurrentMonth = "December"; break}
	}
	
	#Building the full file name that we are going to use to save this report in.
	$_FileName = "Allocations List $_CurrentMonth $((Get-Date).Year).csv"
	$_FileName_Dupes = "Allocations List $_CurrentMonth $((Get-Date).Year)_Dupes.csv"

	#Merging the file path with the file name. 
	$t = $_path+$_FileName
	$t2 = $_path+$_FileName_Dupes


	$_TestPath1 = Test-Path $t

	if ($_TestPath1 = "TRUE")
	{
		Remove-Item $t -Confirm:$True
	}

	$_TestPath2 = Test-Path $t2

	if ($_TestPath2 = "TRUE")
	{
		Remove-Item $t2 -Confirm:$True
	}

	#Add the data we pulled on the user and put it into the csv
	try
	{
		#To export the data of the object we call it first then pipe it out to the Export-CSV command
		$CSVData | Export-Csv -Path $t2.ToString()
		$CSVDataNoDupe | Export-Csv -Path $t.ToString()
		Write-Output "Report has been generated and saved at $_path$_FileName`n"
	}
	catch
	{

		#This block was mostly to see if I could do it but if it cant write to the file name it wants it will pick four random numbers and use them as a file name
		$rng = Get-RNG
		Write-Output "Unable to write to $t.  Chances are the file was open or locked."
		Write-Output "New filename is $_path\$rng.csv"
		$CSVDataNoDupe | Export-Csv -Path $_path\$rng.csv
	}

	#Send-MailMessage -SmtpServer $_EmailServer -from $_EmailFrom -to $_EmailTo -Cc $_EmailCC -Subject "Allocations List $_CurrentMonth $((Get-Date).Year)" -Body $_EmailBody -Attachments $t

	Send-MailMessage -SmtpServer $_EmailServer -from $_EmailFrom -to tkeech@ruralcap.com -Subject "Allocations List $_CurrentMonth $((Get-Date).Year)" -Body $_EmailBody -Attachments $t
}

#Script logic flow
Get-Requirements
Get-UsersFromGroups