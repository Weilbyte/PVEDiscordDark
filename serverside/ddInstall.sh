#!/bin/bash

Say () {
    printf "\e[1;34m $1  \e[0m \n";
}

DotSay () {
    printf "[\e[1;34m*\e[0m] \e[0;34m $1  \e[0m \n"; 
}


Say '[PVE Discord Dark UI Theme Installer]'
Say 'Internet connection required to download files'
Say '>Press any key to begin installation'
read -p ""
Say ' '
DotSay 'Backing up index template file'
cp /usr/share/pve-manager/index.html.tpl /usr/share/pve-manager/index.html.tpl.bak 
DotSay 'Applying stylesheet..'
wget https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/discordDark.css &> /dev/null 
echo "<style type='text/css' media='screen'>" >> /usr/share/pve-manager/index.html.tpl
cat discordDark.css >> /usr/share/pve-manager/index.html.tpl
echo "</style>" >> /usr/share/pve-manager/index.html.tpl
rm discordDark.css
DotSay 'Applied stylesheet!'
DotSay 'Downloading images..'
cd /usr/share/pve-manager/images
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_cephblurp.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_cephwhite.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-cpu.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-hdd.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-ram.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_icon-swap.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_logo.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_mini-bottom.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_mini-top.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_readme &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_tool-sprites.png &> /dev/null 
wget https://github.com/Weilbyte/PVEDiscordDark/raw/master/images/dd_trigger.png &> /dev/null 
DotSay 'Downloaded images!'
Say ''
Say 'Installation finished!'
Say 'o7'  
