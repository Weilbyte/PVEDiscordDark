#!/bin/bash

Say () {
    printf "\e[1;34m $1  \e[0m \n";
}

DotSay () {
    printf "[\e[1;34m*\e[0m] \e[1;34m $1  \e[0m \n"; 
}


Say '[PVE Discord Dark UI Theme JSMOD Installer]'
Say 'Internet connection REQUIRED.'
Say '!!ONLY FOR PVE 6.0-4!!'
Say '>Press any key to begin installation'
read -p ""
Say ' '
DotSay 'Backing up files'
cp /usr/share/pve-manager/js/pvemanagerlib.js /usr/share/pve-manager/js/pvemanagerlib.js.bak 
cp /usr/share/javascript/extjs/charts.js /usr/share/javascript/extjs/charts.js.bak
cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.bak
DotSay 'Replacing files with modded versions'
rm /usr/share/pve-manager/js/pvemanagerlib.js
wget https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/serverside/jsmod/6.0-4/pvemanagerlib.js -P /usr/share/pve-manager/js/ &> /dev/null 
rm /usr/share/javascript/extjs/charts.js
wget https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/serverside/jsmod/6.0-4/charts.js -P /usr/share/javascript/extjs/ &> /dev/null 
rm /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js 
wget https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/serverside/jsmod/6.0-4/proxmoxlib.js -P /usr/share/javascript/proxmox-widget-toolkit/ &> /dev/null 
DotSay 'Applied successfully.'
Say ''
Say 'Installation finished!'
Say 'o7'  
