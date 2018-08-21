command = "powershell.exe -executionpolicy remotesigned -file %userprofile%\AppData\Local\AutoClean\Init-AutoClean.ps1"
 set shell = CreateObject("WScript.Shell")
 shell.Run command,0