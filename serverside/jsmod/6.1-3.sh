#!/bin/bash

Say () {
    printf "\e[1;34m $1  \e[0m \n";
}

DotSay () {
    printf "[\e[1;34m*\e[0m] \e[1;34m $1  \e[0m \n"; 
}


Say '[PVE Discord Dark UI Theme JSMOD Installer]'
Say 'Internet connection REQUIRED.'
Say '!!ONLY FOR PVE 6.0-4 - 6.1-x!!'
Say '>Press any key to begin installation'
read -p ""
Say ' '
DotSay 'Backing up files'
cp /usr/share/pve-manager/js/pvemanagerlib.js /usr/share/pve-manager/js/pvemanagerlib.js.bak 
cp /usr/share/javascript/extjs/charts.js /usr/share/javascript/extjs/charts.js.bak
cp /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js.bak
DotSay 'Modding files'
#replace white with #23272a
sed -i -e "s/'white'/'#23272a'/g" /usr/share/pve-manager/js/pvemanagerlib.js

#Proxmox changed nothing here to last version, so we can use it without modifications
rm /usr/share/javascript/extjs/charts.js
wget https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/serverside/jsmod/6.0-4/charts.js -P /usr/share/javascript/extjs/ &> /dev/null 

sed -i -e "s/#c2ddf2/#7289DA/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
sed -i -e "s/#f5f5f5/#2C2F33/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

DotSay 'Applied patch successfully.'
Say ''
Say 'Installation finished!'
Say 'o7'  
