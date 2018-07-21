

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

#varitey - wallpaper switcher
sudo add-apt-repository ppa:peterlevi/ppa -y

# Moka Icon Pack
# https://snwh.org/moka/download
sudo add-apt-repository -u ppa:snwh/ppa -y

sudo apt-get update

sudo apt-get install snapd node.js npm git variety variety-slideshow gnome-tweaks moka-icon-theme faba-icon-theme faba-mono-icons dconf-tools -y

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
sudo snap install discord spotify docker cpufreq

#Remove not needed packs
sudo apt-get remove rhythmbox firefox thunderbird -y
