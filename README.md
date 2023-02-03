



![](https://i.imgur.com/SnlCyHF.png)

<p align="center">A dark theme for the Proxmox Web UI,<br/> <i>inspired by Discord's color scheme.</i></p>

<p align="center">Everything is dark, including the graphs, context menus and all in between! Eyes need not be fried.</p>    
The theme now runs its own JavaScript code which patches the colors for certain components (and charts). This approach is much better, and safer than what was used previously.

## Installation 
The installation is done via the CLI utility. Run the following commands on the PVE node serving the Web UI:

```
~# wget https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.sh
~# bash PVEDiscordDark.sh install
```
Or this oneliner
```
bash <(curl -s https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.sh ) install
```


## Uninstallation
 To uninstall the theme, simply run the utility with the `uninstall` command.
 
## Installer & Security
The new installer relies on the `/meta/supported` and `/meta/imagelist` files being present in the repository. It also includes a silent mode. Run `bash PVEDiscordDark.sh -h` for usage instructions. 

Furthermore, you will be able to provide the environment variables `REPO` and `TAG` to specify from what repository and from what commit tag to install the theme from.   
`REPO` is in format `Username/Repository` and defaults to `Weilbyte/PVEDiscordDark` (this repository).    
`TAG` defaults to `master`, but it is strongly recommended to use the SHA-1 commit hash for security.

## Offline bundle
If desired, the installation utility can be run offline. Upon detecting a folder called `offline` in the current working directory, the script will enter offline mode and use the resources within that folder instead of retrieving them from GitHub.    

The `offline` folder must have the following files: `meta/[imagelist, supported]`, `PVEDiscordDark/images/*`, `PVEDiscordDark/js/PVEDiscordDark.js`, `PVEDiscordDark/sass/PVEDiscordDark.css`

You can find a zip containing the installer and offline folder under the artifact section of the GitHub Actions under this repository or as an asset attached to releases.

## Notes
Thanks to [jonasled](https://github.com/jonasled) for helping out with the old version, and thanks to [SmallEngineMechanic](https://github.com/smallenginemechanic) for catching bugs for the rewrite!

*Awoo'ing on this repo is encouraged.*
