



![](https://i.imgur.com/SnlCyHF.png)

<p align="center">A dark theme for the Proxmox Web UI,<br/> *inspired by Discord's color scheme.*</p>

<p align="center">Everything is dark, including the graphs, context menus and all in between! Eyes need not be fried.</p>    
The theme now runs its own JavaScript code which patches the colors for certain components (and charts). This approach is much better, and safer than what was used previously.

## Installation 
The installation is very simple thanks to the utility. Run the following commands on the PVE node serving the Web UI and follow the on-screen instructions!     

```
~# wget https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.py
~# python3 PVEDiscordDark.py
   ```

## Uninstallation
 To uninstall the theme, simply run the utility, and if it detects the theme installed it will give you an option to remove it. 

### Updating from the old version
You will need to completely remove the old version (and revert JSMod changes). You can find the uninstall scripts and guides in the `old` branch. 


*Awoo'ing on this repo is allowed.*
