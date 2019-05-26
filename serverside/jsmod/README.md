# PVEDiscordDark Javascript Modifications

As you might have noticed, the CSS edits on its own do not completely darken Proxmox's Web UI.  
HOWEVER, I have found a way to change that - by modifying it's javascript files.  

These modifications are server-side only and currently it is only working on PVE 5.4-3 as I dont have servers that run an older version. If you're running an older version you could send me the files needed so I could take a look at them but for now this is all I have.

## Installation
Download the bash file for your version (currently only supporting 5.4-3) and run it anywhere on your Proxmox **node**. If the changes arent appearing on your browser right away, please clear cache.

## Uninstallation
The bash script backs up the files it replaces. Just remove the modified file and remove the '.bak' extension from the end of the backed up files.

## Files modified
The files modified are..  
* `/usr/share/pve-manager/js/pvemanager.js`
* `/usr/share/javascript/extjs/charts.js`
* `/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js`

For more on whats modified, check [here.](https://github.com/Weilbyte/PVEDiscordDark/blob/master/serverside/jsmod/changes.md)
