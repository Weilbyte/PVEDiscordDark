#!/bin/bash

Say () {
    printf "\e[1;34m $1  \e[0m \n";
}

DotSay () {
    printf "[\e[1;34m*\e[0m] \e[1;34m $1  \e[0m \n"; 
}


Say '[PVE Discord Dark UI Theme Installer]'
Say 'Internet connection required to download files'
Say '>Press any key to begin installation'
read -p ""
Say ' '
DotSay 'Backing up index template file'
cp /usr/share/pve-manager/index.html.tpl /usr/share/pve-manager/index.html.tpl.bak 
DotSay 'Applying stylesheet..'
echo "<link rel='stylesheet' type='text/css' href='/pve2/css/dd_style.css'>" >> /usr/share/pve-manager/index.html.tpl
cd /usr/share/pve-manager/css
wget -O dd_style.css https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/serverside/style.css &> /dev/null 
DotSay 'Applied stylesheet!'
DotSay 'Downloading images..'
cd /usr/share/pve-manager/images
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_cephblurp.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_cephwhite.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-cpu.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-hdd.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-ram.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-swap.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-cd.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-display.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-network.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-cloud.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-serial.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-usb.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-pci.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_logo.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_mini-bottom.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_mini-top.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_readme &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_tool-sprites.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_trigger.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_loading.svg &> /dev/null 

DotSay 'Downloaded images!'
Say ''
Say 'Installation finished!'
Say 'o7'  
