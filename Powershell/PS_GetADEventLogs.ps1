#
# PS_GetADEventLogs.ps1
#
$_ADServers = @("dc-01", "dc-02")
$_path = "C:\Users\userName\Desktop\"
$_ExportFile = "PS_ADLogging.csv"
$_FullPath = $_path + $_ExportFile

Function Get-ReportCSVMethod
{
	foreach ($_ADServers in $_ADServers)
	{
		#import the data so we can try to figure out when it was last ran
		try
		{
			$_CSV = Import-Csv $_FullPath
		}
		catch
		{

		}

		$_Session = New-PSSession -ComputerName $_ADServers
		Write-Output "Please wait, pulling records from $_ADServers."

		$_Responce = Invoke-Command -Session $_Session -ScriptBlock{Get-EventLog -LogName Security -InstanceId 5136 -Newest 10}

		#Close the session to the server
		Remove-PSSession -Session $_Session

		#Import the csv given we could be just adding more data
		try
		{
			#Import the data to a variable... might not be needed anymore though
			try
			{
				$_CSV = Import-Csv -Path $_FullPath
			}
			catch
			{
				Write-Output "Error opening $_FullPath"
			}

			#Export the new data to the CSV
			Try
			{
				$_CSV | Export-Csv $_FullPath -Append
			}
			catch
			{
				Write-Output "Ran into a error saving the report."
			}
		}
		catch
		{
			$_FileExist = Test-Path -Path $_ExportFile
			if (Test-Path -Path $_FullPath )
			{
				Write-Output "Ran into a error importing the file.  Might not be made or unable to open it."
			}
			else
			{
				Write-Output "Dumping data from $_ADServers and making a new report file."
				$_Responce | Export-Csv -path $_FullPath
			}
			
		}	
	}
}

Get-ReportCSVMethod