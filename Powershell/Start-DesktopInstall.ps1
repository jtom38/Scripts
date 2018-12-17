
# Install Sudo because :heart: linux.
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
Set-Executionpolicy unrestricted -s cu -f
scoop install sudo

# Install Choco
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install my packages
# Default applications
choco install signal GoogleChrome discord.install gimp -y
choco install spotify -y --ignore-checksum # Needed to add ignore-checksum for now because it looks like choco has not gotten the updated hash.

# Spotlight search for Windows
choco install wox -y

# Install Dev Tools
sudo choco install vscode dotnetcore-sdk npm nswagstudio visualstudio2017community sql-server-management-studio github-desktop -y

# Games
choco install steam origin -y
chcoc install battle.net -y --allow-empty-checksums # This is needed because Blizzard hosts the download on HTTP

# Use 'https://github.com/Sycnex/Windows10Debloater' to remove the bloat from Windows 10.
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Sycnex/Windows10Debloater/master/Windows10Debloater.ps1', 'Windows10Debloater.ps1')
.\Windows10Debloater.ps1 -Debloat -StopEdgePDF

[System.IO.File]::Delete('Windows10Debloater.ps1')
