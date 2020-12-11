#!/bin/bash
#Script by RisedSky to allow users to update their python script of ProxmoxDiscordDark
#Created : 05/12/2020


currentuser=`whoami | grep 'root'`
default="\e[39m"
green="\e[32m"
red="\e[91m"
yellow="\e[93m"

clear
echo -ne "Verifying that you're root to prevent perm errors \r"
sleep 1
if [ -z "$currentuser" ]
then
    echo -ne "Verifying that you're root to prevent perm errors$red [ERROR] $default \r"
    echo -ne "\nYou are not root !"
    exit 1
fi

echo -ne "Verifying that you're root to prevent perm errors$green [OK] $default \r"
echo -ne '\n'

sleep 1
echo -ne '\n'

sleep 1
echo -ne '#                         (0%) Checking the latestversion\r'
latestversion=`curl -s "https://api.github.com/repos/Weilbyte/PVEDiscordDark/releases/latest" | awk -F '"' '/tag_name/{print $4}'`
echo -ne '#######################   (100%) Checking the latestversion\r'
sleep 1
echo -ne '\n'

file="./currentversion.txt"
currentversion=""
if [ ! -f "$file" ]
then
    echo "$latestversion" > "$file"
    currentversion="$latestversion"
else
    currentversion=`cat $file`
fi

echo "Your version : $currentversion"
echo "Latest version : $latestversion"

if [ ! "$currentversion" = "$latestversion" ]
then
    #Not up tp date
    read -p "$(echo -e $yellow)[Warning] Your version is different, would you like to update ? $(echo -e $default)[y/n]" -n 1 -r
    echo ""   # (optional) move to a new line
    if [[ $REPLY =~ ^[YyOo]$ ]]
    then
        echo -ne "Downloading...\n"
        wget -O "PVEDiscordDark.py" "https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.py"
        echo "$latestversion" > $file
        read -p "$(echo -e $yellow)[Warning] Start the updated script ? $(echo -e $default)[y/n]" -n 1 -r
        echo ""   # (optional) move to a new line
        if [[ $REPLY =~ ^[YyOo]$ ]]
        then
          python3 PVEDiscordDark.py
          exit 0
        fi
     else
        echo -ne "Exiting...\n"
        exit 0
    fi
else
    #Up to date
    echo -e "$green""You have the latest version of the script ! $default"
    exit 0
fi