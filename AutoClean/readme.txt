About:
AutoClean is a small script that is using sdelete.exe to run in the background and clean the active users Temp folder.  This was built to avoid any sanitation problems from programs who never cleanup sensitive data.  This was made to be ran as a user and not an administrator.  No service accounts are needed for this process.

Files:
	1. Init-AutoClean.ps1
		a. Used to initialize the script and checks the repo for files.  Copies them down to the user profile. %UserProfile%\AppData\Local\AutoClean\
		b. Once it downloads the files a Scheduled Task is generated to run as the user so we only have access to this users profile.
	2. Install-AutoCleanTask.ps1
		a. Installs the Task we will use to trigger this event in the background every two hours.
	3. Start-AutoClean.ps1
		a. Currently this will run and only remove all none active files in %temp%
	4. GPOEntry.vbs
		a. Use this to deploy via GPO.  It will go and launch the Init-AutoClean.ps1 file in the Repo.
		b. Using .vbs to hide the window from the user.
	5. LocalEntry.vbs
		a. This references a local copy of the scripts incase the user is offline.  
		b. Install-AutoCleanTask.ps1 references this file.
