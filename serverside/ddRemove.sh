#!/bin/bash

Say () {
    printf "\e[1;34m $1  \e[0m \n";
}

DotSay () {
    printf "[\e[1;34m*\e[0m] \e[0;34m $1  \e[0m \n"; 
}


Say '[PVE Discord Dark UI Theme Remover]'
Say '>Press any key to remove theme'
read -p ""
Say ' '
DotSay 'Reverting html template change'
rm /usr/share/pve-manager/index.html.tpl
cp /usr/share/pve-manager/index.html.tpl.bak /usr/share/pve-manager/index.html.tpl
DotSay 'Removing images'
cd /usr/share/pve-manager/images
rm dd_*
Say ''
Say 'Theme removed!'
Say 'o7'  
