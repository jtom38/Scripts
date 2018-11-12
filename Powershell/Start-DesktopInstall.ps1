
# Install Sudo because :heart: linux.
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
Set-Executionpolicy unrestricted -s cu -f
scoop install sudo

# Install Choco
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install my packages

# Install Dev Tools
sudo choco install vscode dotnetcore-sdk npm nswagstudio visualstudio2017community sql-server-management-studio github-desktop -y

# Video Game
choco install signal -y
choco install GoogleChrome -y
choco install discord -y
choco install steam -y
choco install spotify -y
chcoo install gimp -y

# Remove Windows 10 Apps
Get-AppxPackage *Messaging* | Remove-AppxPackage
Get-AppxPackage *Xbox* | Remove-AppxPackage
Get-AppxPackage *MarchofEmpires* | Remove-AppxPackage
get-appxpackage *3dbuilder* | remove-appxpackage
get-appxpackage *alarms* | remove-appxpackage
get-appxpackage *appconnector* | remove-appxpackage
get-appxpackage *appinstaller* | remove-appxpackage
get-appxpackage *communicationsapps* | remove-appxpackage
get-appxpackage *calculator* | remove-appxpackage
get-appxpackage *camera* | remove-appxpackage
get-appxpackage *feedback* | remove-appxpackage
get-appxpackage *officehub* | remove-appxpackage
get-appxpackage *getstarted* | remove-appxpackage
get-appxpackage *skypeapp* | remove-appxpackage
get-appxpackage *zunemusic* | remove-appxpackage
get-appxpackage *zune* | remove-appxpackage
get-appxpackage *maps* | remove-appxpackage
get-appxpackage *messaging* | remove-appxpackage
get-appxpackage *solitaire* | remove-appxpackage
get-appxpackage *wallet* | remove-appxpackage
get-appxpackage *connectivitystore* | remove-appxpackage
get-appxpackage *bingfinance* | remove-appxpackage
get-appxpackage *bing* | remove-appxpackage
get-appxpackage *zunevideo* | remove-appxpackage
get-appxpackage *bingnews* | remove-appxpackage
get-appxpackage *onenote* | remove-appxpackage
get-appxpackage *oneconnect* | remove-appxpackage
get-appxpackage *mspaint* | remove-appxpackage
get-appxpackage *people* | remove-appxpackage
get-appxpackage *windowsphone* | remove-appxpackage
get-appxpackage *photos* | remove-appxpackage
get-appxpackage *sway* | remove-appxpackage
get-appxpackage *3d* | remove-appxpackage
get-appxpackage *soundrecorder* | remove-appxpackage
get-appxpackage *bingweather* | remove-appxpackage
get-appxpackage *holographic* | remove-appxpackage
get-appxpackage *xbox* | remove-appxpackage
Get-AppxPackage *twitter* | Remove-AppxPackage
Get-AppxPackage *minecraft* | Remove-AppxPackage
Get-AppxPackage *advertising* | Remove-AppxPackage