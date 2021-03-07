#!/usr/bin/python3

import os
import sys
import time
import subprocess
import urllib.request
import os.path
import shutil
import argparse

ACTION = None

images = [
    'dd_cephblurp.png', 'dd_cephwhite.png',
    'dd_icon-cpu.png', 'dd_icon-hdd.png',
    'dd_icon-ram.png', 'dd_icon-swap.png',
    'dd_icon-cd.png', 'dd_icon-display.png',
    'dd_icon-network.png', 'dd_icon-cloud.png',
    'dd_icon-serial.png', 'dd_icon-usb.png',
    'dd_icon-pci.png', 'dd_logo.png',
    'dd_mini-bottom.png', 'dd_mini-top.png',
    'dd_readme', '/dd_tool-sprites.png',
    'dd_trigger.png', 'dd_loading.svg',
    'dd_icon-die.svg', 'dd_clear-trigger.png']

class colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    NORMAL = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def clear():
    if ACTION == None:
        print("\033c", end="")

def cprint(color, text, bold=False, inline=False):
    endc = '\n'
    if inline:
        endc = ''
    if bold:
        print(colors.BOLD)
    print(color + text + colors.NORMAL, end=endc)

def getPVEVersion():
    pv = subprocess.check_output('pveversion --verbose | grep pve-manager | cut -c 14- | cut -c -6', shell=True, stderr=open(os.devnull, 'w'))
    pv = pv.decode('ascii').replace(" ", "").replace("\n","")
    if (('/bin/' in pv) or (len(pv) > 7)):
        return ""
    else:
        return pv

def checkPVE():
    ver = getPVEVersion()
    if (len(ver) < 1):
        cprint(colors.FAIL, 'Unable to detect Proxmox.', True)
        cprint(colors.NORMAL, 'A Proxmox installation could not be detected.')
        exit(1)
    else:
        cprint(colors.OKGREEN, '\nPVE ' + ver + ' detected.')

def checkConn():
    try:
        urllib.request.urlopen('http://github.com')
        return
    except:
        cprint(colors.FAIL, 'An Internet connection is required to install PVEDiscordDark.', True)
        cprint(colors.NORMAL, 'Connect to the Internet and try again.')
        exit(1)

def themeIsInstalled():
    tplUsesTheme = False
    tplFile = open('/usr/share/pve-manager/index.html.tpl')
    tplLines = tplFile.readlines()
    for line in tplLines:
        if ("<link rel='stylesheet' type='text/css' href='/pve2/css/dd_style.css'>" in line or "<script type='text/javascript' src='/pve2/js/dd_patcher.js'></script>" in line):
            tplUsesTheme = True
    if (os.path.isfile('/usr/share/pve-manager/css/dd_style.css') or tplUsesTheme):
        return True
    return False

def installTheme():
    clear()
    doHeader()
    baseURL = os.getenv('BASEURL', 'https://github.com/Weilbyte/PVEDiscordDark/raw/' + os.getenv("BRANCH", "master"))
    cprint(colors.NORMAL, '\nBacking up index template file..')
    shutil.copyfile('/usr/share/pve-manager/index.html.tpl', '/usr/share/pve-manager/index.html.tpl.bak')
    cprint(colors.NORMAL, 'Downloading stylesheet..')
    urllib.request.urlretrieve(baseURL + '/PVEDiscordDark/sass/PVEDiscordDark.css', '/usr/share/pve-manager/css/dd_style.css')
    cprint(colors.NORMAL, 'Downloading patcher..')
    urllib.request.urlretrieve(baseURL + '/PVEDiscordDark/js/PVEDiscordDark.js', '/usr/share/pve-manager/js/dd_patcher.js')
    cprint(colors.NORMAL, 'Applying stylesheet and patcher..')
    with open('/usr/share/pve-manager/index.html.tpl', 'a') as tplFile:
        tplFile.write("<link rel='stylesheet' type='text/css' href='/pve2/css/dd_style.css'>")
        tplFile.write("<script type='text/javascript' src='/pve2/js/dd_patcher.js'></script>")
    for index, image in enumerate(images):
        imageCurrent = index + 1
        cprint(colors.NORMAL, 'Downloading images [' + str(imageCurrent) + '/' + str(len(images)) + ']..\r', False, True)
        urllib.request.urlretrieve(baseURL + '/PVEDiscordDark/images/' + image, '/usr/share/pve-manager/images/' + image)
    cprint(colors.OKGREEN, '\nTheme installed successfully!', True)
    if ACTION == None:
        cprint(colors.NORMAL, 'Press [ENTER] to go back.')
        input('')
        doMainMenu()

def uninstallTheme():
    clear()
    doHeader()
    cprint(colors.NORMAL, '\nCleaning up index template file..')
    with open('/usr/share/pve-manager/index.html.tpl', 'r+') as tplFile:
        tplLines = tplFile.readlines()
        tplFile.seek(0)
        for line in tplLines:
            if ("<link rel='stylesheet' type='text/css' href='/pve2/css/dd_style.css'>" not in line or "<script type='text/javascript' src='/pve2/js/dd_patcher.js'></script>" not in line):
                tplFile.write(line)
        tplFile.truncate()
    if os.path.exists('/usr/share/javascript/extjs/charts.js.bak'):
        cprint(colors.NORMAL, 'Reverting charts.js replacement..')
        os.remove('/usr/share/javascript/extjs/charts.js')
        shutil.copyfile('/usr/share/javascript/extjs/charts.js.bak', '/usr/share/javascript/extjs/charts.js')
        os.remove('/usr/share/javascript/extjs/charts.js.bak')
    if os.path.exists('/usr/share/pve-manager/css/dd_style.css'):
        cprint(colors.NORMAL, 'Removing stylesheet..')
        os.remove('/usr/share/pve-manager/css/dd_style.css')
    if os.path.exists('/usr/share/pve-manager/js/dd_patcher.js'):
        cprint(colors.NORMAL, 'Removing patcher..')
        os.remove('/usr/share/pve-manager/js/dd_patcher.js')
    cprint(colors.NORMAL, 'Removing images..')
    for asset in os.listdir('/usr/share/pve-manager/images/'):
        if asset.startswith('dd_'):
            os.remove('/usr/share/pve-manager/images/' + asset)
    cprint(colors.OKGREEN, '\n\nTheme uninstalled successfully!', True)
    if ACTION == None:
        cprint(colors.NORMAL, 'Press [ENTER] to go back.')
        input('')
        doMainMenu()

def doHeader():
    cprint(colors.HEADER, '[~]', True, True)
    cprint(colors.NORMAL, ' PVEDiscordDark Utility (DEPRECATED)\nThis installer is now deprecated, please use PVEDiscordDark.sh\n', False, True)

def doMainMenu():
    clear()
    doHeader()
    isInstalled = themeIsInstalled()
    cprint(colors.NORMAL, '[I]', True, True)
    cprint(colors.NORMAL, ' Install theme', False, True)
    if isInstalled:
        cprint(colors.NORMAL, '[U]', True, True)
        cprint(colors.NORMAL, ' Uninstall theme', False, True)
    cprint(colors.NORMAL, '[Q]', True, True)
    cprint(colors.NORMAL, ' Exit', False, True)
    choice = input('\n\n>? ')
    choice = choice.upper().replace(" ", "")
    if choice == 'I':
        installTheme()
    elif (choice == 'U' and isInstalled):
        uninstallTheme()
    elif choice == 'Q':
        exit(0)
    else:
        doMainMenu()

def main():
    parser = argparse.ArgumentParser(description='PVEDiscordDark Theme Utility (DEPRECATED)')
    parser.add_argument('--action', '-a', choices=['install', 'uninstall'], help='action for unattended mode')
    args = parser.parse_args()
    global ACTION
    ACTION = args.action
    checkPVE()
    checkConn()
    time.sleep(0.5)
    if ACTION == None:
        try:
            doMainMenu()
        except KeyboardInterrupt:
            print('\n')
            exit(0)
    else:
        if ACTION == 'install':
            installTheme()
        else:
            if themeIsInstalled():
                uninstallTheme()

if __name__ == "__main__":
    main()
