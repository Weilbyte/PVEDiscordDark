# Develop Branch

## Setting up a development environment:
1. Clone this repository/branch
```shellsession
$ git clone https://github.com/b-/PVEThemes -b develop
$ cd PVEThemes/PVEDiscordDark
```
2. Make sure you have python3-pip and python3-venv installed. (python3-wheel is recommended as well). This command will be a little different if you're not doing this development on a Debian or Ubuntu machine. 
```shellsession
$ sudo apt update && sudo apt install python3-pip python3-wheel python3-venv
```
3. Create and activate a Python venv, and install the requirements
```shellsession
$ python3 -m venv venv
$ . venv/bin/activate
(venv) $ python3 -m pip install -r requirements.txt
Collecting libsass
  Downloading libsass-0.22.0-cp37-abi3-macosx_10_15_x86_64.whl (1.1 MB)
     |████████████████████████████████| 1.1 MB 599 kB/s
Collecting watchdog
  Downloading watchdog-2.2.1-cp39-cp39-macosx_10_9_x86_64.whl (88 kB)
     |████████████████████████████████| 88 kB 8.1 MB/s
Installing collected packages: watchdog, libsass
Successfully installed libsass-0.22.0 watchdog-2.2.1
```
4. Now you can build the css
```shellsession
(venv) $ python3 sassy.py
Compiled PVEDiscordDark.sass to PVEDiscordDark.css
```
5. If you want to automatically recompile it upon any changes:
```shellsession
(venv) $ python3 sassy.py w
```
6. If you want to serve a test page:
(TODO: figure out how that works)
7. You can install a built copy right from the dev environment if you're brave enough to work on this on your actual proxmox server:
```shellsession
$ sudo ./install.sh install
```
or
```shellsession
$ sudo ./install.sh update
```


![](https://i.imgur.com/SnlCyHF.png)

<p align="center">A dark theme for the Proxmox Web UI,<br/> <i>inspired by Discord's color scheme.</i></p>

<p align="center">Everything is dark, including the graphs, context menus and all in between! Eyes need not be fried.</p>    
The theme now runs its own JavaScript code which patches the colors for certain components (and charts). This approach is much better, and safer than what was used previously.

## Installation 
The installation is done via the CLI utility. Run the following commands on the PVE node serving the Web UI:  Clearing browser cache is necessary to see the changes.

```
~# wget https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.sh
~# bash PVEDiscordDark.sh install
```
Or this oneliner
```
bash <(curl -s https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.sh ) install
```

Note that you will need to run the install command every time `pve-manager` is updated (i.e. after every Proxmox update)

## Uninstallation
 To uninstall the theme, simply run the utility with the `uninstall` command. Clearing browser cache is necessary to see the changes.
 
## Installer & Security
The new installer relies on the `/meta/supported` and `/meta/imagelist` files being present in the repository. It also includes a silent mode. Run `bash PVEDiscordDark.sh -h` for usage instructions. 

Furthermore, you will be able to provide the environment variables `REPO` and `TAG` to specify from what repository and from what commit tag to install the theme from.   
`REPO` is in format `Username/Repository` and defaults to `Weilbyte/PVEDiscordDark` (this repository).    
`TAG` defaults to `master`, but it is strongly recommended to use the SHA-1 commit hash for security.

## Offline bundle
If desired, the installation utility can be run offline. Upon detecting a folder called `offline` in the current working directory, the script will enter offline mode and use the resources within that folder instead of retrieving them from GitHub.    

The `offline` folder must have the following files: `meta/[imagelist, supported]`, `PVEDiscordDark/images/*`, `PVEDiscordDark/js/PVEDiscordDark.js`, `PVEDiscordDark/sass/PVEDiscordDark.css`

You can find a zip containing the installer and offline folder under the artifact section of the GitHub Actions under this repository or as an asset attached to releases.

## Contributors
Thanks to everybody who contributed to this project, and additional thanks to [Crinisus](https://github.com/crinisus) for catching bugs for the rewrite!

<a href="https://github.com/weilbyte/pvediscorddark/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=weilbyte/pvediscorddark" />
</a>


*Awoo'ing on this repo is encouraged.*
