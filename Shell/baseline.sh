


# .net core 2.1
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt --fix-broken install -y
rm packages-microsoft-prod.deb
sudo apt-get install apt-transport-https -y
sudo apt-get update
sudo apt-get install dotnet-sdk-2.1 -y
dotnet dev-certs https

# Teamviewer install
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -i teamviewer_amd64.deb 
sudo apt --fix-broken install -y
rm teamviewer_amd64.deb

# MongoDb Atlus
wget https://downloads.mongodb.com/compass/mongodb-compass-community_1.14.6_amd64.deb
sudo dpkg -i mongodb-compass-community_1.14.6_amd64.deb
sudo apt --fix-broken install -y
rm mongodb-compass-community_1.14.6_amd64.deb

# Google Chrome
# I am use to this :V
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
sudo apt-get --fix-broken install -y
rm google-chrome-stable_current_amd64.deb

# Discord
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
sudo apt --fix-broken install -y
rm discord.deb

# Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# GitKraken
# was not working for me when I ran the app.  Migration to snap for now.
# wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
# sudo dpkg -i gitkraken-amd64.deb
# sudo apt --fix-broken install
# rm gitkraken-amd64.deb

# Signal Desktop
sudo apt-get install gurl -y
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

# Visual Studio Code
wget -O vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
sudo dpkg -i vscode.deb
sudo apt --fix-broken insall -y
rm vscode.deb

# Rider - C# IDE
wget https://download.jetbrains.com/rider/JetBrains.Rider-2018.1.3.tar.gz
tar -xvf JetBrains.Rider-2018.1.3.tar.gz

# Start the application in the background
./JetBrains\ Rider-2018.1.3/bin/rider.sh &

rm JetBrains.Rider-2018.1.3.tar.gz

#varitey - wallpaper switcher
sudo add-apt-repository ppa:peterlevi/ppa -y

# Moka Icon Pack
# https://snwh.org/moka/download
sudo add-apt-repository -u ppa:snwh/ppa -y

# Steam
wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
sudo gdpk -i steam.deb
sudo apt --fix-broken install -y
steam &
rm steam.deb

# Lutris - Open Gaming Platform
# https://lutris.net

ver=$(lsb_release -sr); if [ $ver != "18.04" -a $ver != "17.10" -a $ver != "17.04" -a $ver != "16.04" ]; then ver=18.04; fi echo "deb http://download.opensuse.org/repositories/home:/strycore/xUbuntu_$ver/ ./" | sudo tee /etc/apt/sources.list.d/lutris.list
wget -q http://download.opensuse.org/repositories/home:/strycore/xUbuntu_$ver/Release.key -O- | sudo apt-key add -


# Virtual Box - Who doesnt need a VM at some point.
# https://www.virtualbox.org/wiki/Linux_Downloads
wget https://www.virtualbox.org/download/oracle_vbox_2016.asc
sudo apt-key add oracle_vbox_2016.asc


sudo apt-get update

sudo apt-get install virtualbox -y

# Lets you send Wake Over Lan packets.
# https://www.cyberciti.biz/tips/linux-send-wake-on-lan-wol-magic-packets.html
sudo atp-get install eitherwake -y

# Linux RDP Client
sudo apt-get install remmina -y

sudo apt-get install lutris -y
sudo apt-get install snapd -y
sudo apt-get install variety variety-slideshow -y
sudo apt-get install moka-icon-theme faba-icon-theme faba-mono-icons -y
sudo apt-get install dconf-tools -y
sudo apt-get install gimp -y
sudo apt-get install spotify-client -y
sudo apt-get install docker-compose -y
sudo apt-get install signal-desktop -y
sudo apt-get install make -y
sudo apt-get install node.js -y
sudo apt-get install npm -y
sudo apt-get install git -y

# Screenshot tool
sudo apt-get install shutter -y

sudo snap install gitkraken -y

#If KDE 
if [ $DESKTOP_SESSION = "plasma" ]
then
    sudo apt-get install yakuake -y
fi

# Migrated over to KDE so this is now needed for my own use.
if [ $DESKTOP_SESSION = "gnome" ] 
then
    sudo apt-get install gnome-tweaks -y

    # Adjust Ubuntu Dock
    # https://linuxconfig.org/how-to-customize-dock-panel-on-ubuntu-18-04-bionic-beaver-linux
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 64
    gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true

    # Did this break something?  We can reset it
    # gsettings reset org.gnome.shell.extensions.dash-to-dock dash-max-icon-size

    # Gnome Topbar fix
    git clone https://github.com/phocean/TopIcons-plus.git
    cd TopIcons-plus
    make install
    sudo make install INSTALL_PATH=/usr/share/gnome-shell/extensions
    cd ..
    rm TopIcons-plus -r -f

    echo "Gnome Topbar fix has been installed.  Logout and login again then check gnome-tweak for the fix."

    #Snaps are built to auto update
    #might move docker to apt
    sudo snap install cpufreqd

    # cpuFreq Gnome Extension
    # https://extensions.gnome.org/extension/1082/cpufreq/
    wget https://raw.githubusercontent.com/konkor/cpufreq/master/install.sh
    chmod 777 install.sh
    ./install.sh
    rm ./install.sh
fi

# Remove not needed packs
sudo apt-get remove rhythmbox firefox thunderbird -y

# Remove anything that is no longer needed
sudo atp-get autoremove -y

# Check for updates
sudo apt-get upgrade -y