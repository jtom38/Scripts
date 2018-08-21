command = "powershell.exe -executionpolicy remotesigned -file \\directorsmortgage.net\SYSVOL\directorsmortgage.net\scripts\AutoClean\Init-AutoClean.ps1"
 set shell = CreateObject("WScript.Shell")
 shell.Run command,0