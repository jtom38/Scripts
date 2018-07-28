

#Dependancies
#.net core 2.1
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install dotnet-sdk-2.1 -y

#teamviewer install
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -i teamviewer_amd64.deb #will be missing depandies
sudo apt --fix-broken instal #will now fix them

#MongoDb Atlus
wget https://downloads.mongodb.com/compass/mongodb-compass-community_1.14.6_amd64.deb
sudo dpkg -i mongodb-compass-community_1.14.6_amd64.deb
sudo apt --fix-broken install
rm mongodb-compass-community_1.14.6_amd64.deb

# Google Chrome
# I am use to this :V
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
rm google-chrome-stable_current_amd64.deb

# Discord
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
sudo apt --fix-broken install
rm discord.deb

# Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# GitKraken
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken-amd64.deb
sudo apt --fix-broken install
rm gitkraken-amd64.deb

# Signal Desktop
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

# Visual Studio Code
wget -O vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
sudo dpkg -i vscode.deb
rm vscode.deb

#varitey - wallpaper switcher
sudo add-apt-repository ppa:peterlevi/ppa -y

# Moka Icon Pack
# https://snwh.org/moka/download
sudo add-apt-repository -u ppa:snwh/ppa -y

sudo apt-get update

sudo apt-get install curl -y
sudo apt-get install snapd -y 
sudo apt-get install node.js -y 
sudo apt-get install npm -y
sudo apt-get install git -y
sudo apt-get install variety variety-slideshow -y
sudo apt-get install gnome-tweaks -y
sudo apt-get install moka-icon-theme faba-icon-theme faba-mono-icons 
sudo apt-get install dconf-tools -y
sudo apt-get install gimp -y
sudo apt-get install spotify-client -y
sudo apt-get install docker-compose -y
sudo apt-get install signal-desktop -y

# Adjust Ubuntu Dock
# https://linuxconfig.org/how-to-customize-dock-panel-on-ubuntu-18-04-bionic-beaver-linux
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 64
gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true

# Did this break something?  We can reset it
# gsettings reset org.gnome.shell.extensions.dash-to-dock dash-max-icon-size

#Snaps are built to auto update
#might move docker to apt
sudo snap install cpufreqd

# cpuFreq Gnome Extension
# https://extensions.gnome.org/extension/1082/cpufreq/
wget https://raw.githubusercontent.com/konkor/cpufreq/master/install.sh
chmod 777 install.sh
./install.sh
rm ./install.sh

# Generate web apps
sudo npm install nativefier -g
mkdir ./webapps
cd ./webapps
nativefier --name "OneNote" https://www.onenote.com/hrd?wdorigin=ondcauth2&wdorigin=ondcnotebooks
nativefier --name "Asana" https://app.asana.com/app/asana/-/login
nativefier --name "LastPass" https://lastpass.com/&ac=1&lpnorefresh=1&fromwebsite=1&newvault=1&nk=1

#Remove not needed packs
sudo apt-get remove rhythmbox firefox thunderbird -y
