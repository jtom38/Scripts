#
# PS-CleanOldProfiles.ps1
#

param
(
	[string]$_userDebugMode = $( Read-Host "Turn on debug mode? Values: 'TRUE' or 'FALSE'"),
	[int]$_userDays = 30 
)

$_specialFalse = Get-WMIObject -class Win32_UserProfile | Where {(!$_.Special) -and ($_.LastUseTime) -and ($_.ConvertToDateTime($_.LastUseTime) -lt (Get-Date).AddDays(-$_userDays))} | select LocalPath, LastUseTime
$_specialFalseCounter = $_specialFalse | measure

$_blacklist = @('null', 'null')
$_blacklistCounter = $_blacklist | measure
$_blacklistMatch = $false

$_folderName = ""
$_folderLastWriteTime = ""

#display the mode we are in
switch($_userDebugMode.ToLower())
{
	"false" 
	{
		 Write-Host -ForegroundColor Green "Debug Mode: OFF" 
	}
	"true" 
	{
		Write-Host -ForegroundColor Green "Debug Mode: ON"
	}
	default 
	{ 
		Write-Host -ForegroundColor Green "Debug Mode: ON" 
	}
}


#Core Logic
if($_specialFalseCounter.Count -eq 0)
{
	Write-Host -ForegroundColor Green "No profiles found that needed to be removed."
}
else
{
	for($i = 0; $i -lt $_specialFalseCounter.Count; $i++)
	{
		$_folderName = $_specialFalse[$i].LocalPath.TrimStart("C:\Users\")

		for($b = 0; $b -lt $_blacklistCounter.Count; $b++)
		{
			if($_folderName -eq $_blacklist[$b])
			{	
				$_blacklistMatch = $true # found a match so we need to skip it
				$b = $_blacklistCounter.Count # take the value to max to jump out of loop
			}
			else
			{
				$_blacklistMatch = $false # Makes sure the value is set to false
			}
		}

		if($_blacklistMatch -eq $false)
		{		
			try
			{				
				switch($_userDebugMode.ToLower())
				{					
					"false" 
					{ 
						Get-WMIObject -class Win32_UserProfile | Where {($_.LocalPath -eq $_specialFalse[$i].LocalPath)} | Remove-WmiObject #This will fail if the script was not ran in an Administrative Powershell Session
						Write-Host "Processed $i/$_specialFalseCounter.Count"
					} 
					"true" { Write-Host -ForegroundColor Red "Delete TRUE: $_folderName" }
					default { Write-Host -ForegroundColor Red "Delete TRUE: $_folderName" }
				}					
			}
			catch
			{
				Write-Host("Unable to delete $_specialFalse[$i].LocalPath") -ForegroundColor Red
			}
		}
		else
		{
			Write-Host -ForegroundColor Cyan "BlackList TRUE: $_folderName"
		}
	}
}