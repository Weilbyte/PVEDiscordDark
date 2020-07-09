# PVEDiscordDark Javascript Modifications (DEPRECATED)

The Javascript modifications are now DEPRECATED. They will not recieve any updates. The rewrite has all of these changes integrated in a much safer and non-damaging way.

Please uninstall it by following the instructions below.

## Uninstallation
The install scripts back up the files they replace (the backups are placed in the same directory as the original file). Just remove the modified file and remove the '.bak' extension from the end of the backed up files.

The files that are modified are..  
* `/usr/share/pve-manager/js/pvemanager.js`
* `/usr/share/javascript/extjs/charts.js`
* `/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js`

### Backup unavailable
If the backup you have is unavailable/not working, then you can either get the original file from this repo directory (if you have one of those 3 supported versions) or you can update your PVE install to the latest version by following this - https://pve.proxmox.com/wiki/Downloads#Update_a_running_Proxmox_Virtual_Environment_6.x_to_latest_6.2. 
Updating will replace the files (apart from charts.js - whose original you can grab from any PVE version folder from here since its not changed).
