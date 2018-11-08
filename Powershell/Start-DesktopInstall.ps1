
# Install Sudo because :heart: linux.
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
Set-Sxecutionpolicy unrestricted -s cu -f
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