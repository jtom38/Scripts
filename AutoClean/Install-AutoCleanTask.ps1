# Installs the Scheduled Task to run as the user

$UserName = $Env:USERNAME
$TaskName = [System.Text.StringBuilder]::new().Append("AutoClean-").Append($UserName)

$Result = Get-ScheduledTask -TaskName $TaskName | Measure-Object

if($Result.Count -eq 0){
    [System.Console]::WriteLine("Unable to find any tasks named: $TaskName.  Installing...")
    
    #$ActionName = [System.Text.StringBuilder]::new().Append("powershell.exe -executionpolicy remotesigned -file C:\Users\").Append($UserName).Append("\AppData\Local\AutoClean\Init-AutoClean.ps1")
    $ActionName = [System.Text.StringBuilder]::new().Append($env:USERPROFILE).Append("\AppData\Local\AutoClean\LocalEntry.vbs")
    #$ActionName = "powershell.exe -file C:\Users\$UserName\AppData\Local\AutoClean\Init-AutoClean.ps1"
    $Action = New-ScheduledTaskAction -Execute $ActionName

    #$Trigger = New-ScheduledTaskTrigger -Daily -At 12am -DaysInterval 7 -RepetitionInterval $Interval  
    $Trigger = @()
    $Trigger += New-ScheduledTaskTrigger -Daily -At 12am
    $Trigger += New-ScheduledTaskTrigger -Daily -At 2am
    $Trigger += New-ScheduledTaskTrigger -Daily -At 4am
    $Trigger += New-ScheduledTaskTrigger -Daily -At 6am
    $Trigger += New-ScheduledTaskTrigger -Daily -At 8am
    $Trigger += New-ScheduledTaskTrigger -Daily -At 10am
    $Trigger += New-ScheduledTaskTrigger -Daily -At 12pm
    $Trigger += New-ScheduledTaskTrigger -Daily -At 2pm
    $Trigger += New-ScheduledTaskTrigger -Daily -At 4pm
    $Trigger += New-ScheduledTaskTrigger -Daily -At 6pm
    $Trigger += New-ScheduledTaskTrigger -Daily -At 8pm
    $Trigger += New-ScheduledTaskTrigger -Daily -At 10pm
    #$Trigger = New-ScheduledTaskTrigger -AtLogOn

    #$Principal = New-ScheduledTaskPrincipal "DMI\$UserName"

    #$Settings = New-ScheduledTaskSettingsSet
    #$NewTask = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings

    Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -RunLevel Limited
}