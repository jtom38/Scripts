
function Import-Settings {

    Process{

        $json = get-content -Path ".\config.json" | ConvertFrom-Json
        
        # Core Script vars
        $script:SourceServer = $json.SourceServer
        $script:SourceDirectory = $json.SourceDirectory
        $script:DestinationDirectory = $json.DestinationDirectory
        $script:FullBackupHold = $json.FullBackupHold
        $script:DiffBackupHold = $json.DiffBackupHold
        $script:LogBackupHold = $json.LogBackupHold
        $script:IsDupeFile = $json.IsDupeFile
        $script:SleepTimerMinutes = $json.SleepTimerMinutes

        # Smtp vars
        $script:SmtpTo = $json.Smtp.To
        $script:SmtpFrom = $json.Smtp.From
        $Script:SmtpServer = $json.Smtp.Server
        $script:SmtpPort = $json.Smtp.Port
        $script:SmtpUserName = $json.Smtp.Credentials.UserName
        $Script:SmtpPassword = $json.Smtp.Crednetials.Password
    }
}