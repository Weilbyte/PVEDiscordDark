#!/bin/bash
# https://github.com/Weilbyte/PVEDiscordDark

umask 022

#region Consts
RED='\033[0;31m'
BRED='\033[0;31m\033[1m'
GRN='\033[92m'
WARN='\033[93m'
BOLD='\033[1m'
REG='\033[0m'
CHECKMARK='\033[0;32m\xE2\x9C\x94\033[0m'

TEMPLATE_FILE="/usr/share/pve-manager/index.html.tpl"
SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"
SCRIPTPATH="${SCRIPTDIR}$(basename "${BASH_SOURCE[0]}")"

OFFLINEDIR="${SCRIPTDIR}offline"

REPO=${REPO:-"Weilbyte/PVEDiscordDark"}
DEFAULT_TAG="master"
TAG=${TAG:-$DEFAULT_TAG}
BASE_URL="https://raw.githubusercontent.com/$REPO/$TAG"

OFFLINE=false
#endregion Consts

#region Prerun checks
if [[ $EUID -ne 0 ]]; then
    echo -e >&2 "${BRED}Root privileges are required to perform this operation${REG}";
    exit 1
fi

hash sed 2>/dev/null || { 
    echo -e >&2 "${BRED}sed is required but missing from your system${REG}";
    exit 1;
}

hash pveversion 2>/dev/null || { 
    echo -e >&2 "${BRED}PVE installation required but missing from your system${REG}";
    exit 1;
}

if test -d "$OFFLINEDIR"; then
    echo "Offline directory detected, entering offline mode."
    OFFLINE=true
else
    hash curl 2>/dev/null || { 
        echo -e >&2 "${BRED}cURL is required but missing from your system${REG}";
        exit 1;
    }
fi

if [ "$OFFLINE" = false ]; then
    curl -sSf -f https://raw.githubusercontent.com/ &> /dev/null || {
        echo -e >&2 "${BRED}Could not establish a connection to GitHub (https://raw.githubusercontent.com)${REG}";
        exit 1;
    }

    if [ $TAG != $DEFAULT_TAG ]; then
        if !([[ $TAG =~ [0-9] ]] && [ ${#TAG} -ge 7 ] && (! [[ $TAG =~ ['!@#$%^&*()_+.'] ]]) ); then 
            echo -e "${WARN}It appears like you are using a non-default tag. For security purposes, please use the SHA-1 hash of said tag instead${REG}"
        fi
    fi
fi
#endregion Prerun checks

PVEVersion=$(pveversion --verbose | grep pve-manager | cut -c 14- | cut -c -6) # Below pveversion pre-run check
PVEVersionMajor=$(echo $PVEVersion | cut -d'-' -f1)

#region Helper functions
function checkSupported {   
    if [ "$OFFLINE" = false ]; then
        local SUPPORTED=$(curl -f -s "$BASE_URL/meta/supported")
    else
        local SUPPORTED=$(cat "$OFFLINEDIR/meta/supported")
    fi

    if [ -z "$SUPPORTED" ]; then 
        if [ "$OFFLINE" = false ]; then
            echo -e "${WARN}Could not reach supported version file ($BASE_URL/meta/supported). Skipping support check.${REG}"
        else
            echo -e "${WARN}Could not find supported version file ($OFFLINEDIR/meta/supported). Skipping support check.${REG}"
        fi
    else 
        local SUPPORTEDARR=($(echo "$SUPPORTED" | tr ',' '\n'))
        if ! (printf '%s\n' "${SUPPORTEDARR[@]}" | grep -q -P "$PVEVersionMajor"); then
            echo -e "${WARN}You might encounter issues because your version ($PVEVersionMajor) is not matching currently supported versions ($SUPPORTED)."
            echo -e "If you do run into any issues on >newer< versions, please consider opening an issue at https://github.com/Weilbyte/PVEDiscordDark/issues.${REG}"
        fi
    fi
}

function isInstalled {
    if (grep -Fq "<link rel='stylesheet' type='text/css' href='/pve2/css/dd_style.css'>" $TEMPLATE_FILE &&
        grep -Fq "<script type='text/javascript' src='/pve2/js/dd_patcher.js'></script>" $TEMPLATE_FILE &&
        [ -f "/usr/share/pve-manager/css/dd_style.css" ] && [ -f "/usr/share/pve-manager/js/dd_patcher.js" ]); then 
        true
    else 
        false
    fi
}

#endregion Helper functions

#region Main functions
function usage {
    if [ "$_silent" = false ]; then
        echo -e "Usage: $0 [OPTIONS...] {COMMAND}\n"
        echo -e "Manages the PVEDiscordDark theme."
        echo -e "  -h --help            Show this help"
        echo -e "  -s --silent          Silent mode\n"
        echo -e "Commands:"
        echo -e "  status               Check current theme status (returns 0 if installed, and 1 if not installed)"
        echo -e "  install              Install the theme"
        echo -e "  uninstall            Uninstall the theme"
        echo -e "  update               Update the theme (runs uninstall, then install)"
    #    echo -e "  utility-update       Update this utility\n" (to be implemented)
        echo -e "Exit status:"
        echo -e "  0                    OK"
        echo -e "  1                    Failure"
        echo -e "  2                    Already installed, OR not installed (when using install/uninstall commands)\n"
        echo -e "Report issues at: <https://github.com/Weilbyte/PVEDiscordDark/issues>"
    fi
}

function status {
    if [ "$_silent" = false ]; then
        echo -e "Theme"
        if isInstalled; then
            echo -e "  Status:      ${GRN}present${REG}"
        else
            echo -e "  Status:      ${RED}not present${REG}"
        fi
        echo -e "  CSS:         $(sha256sum /usr/share/pve-manager/css/dd_style.css 2>/dev/null  || echo N/A)"
        echo -e "  JS:          $(sha256sum /usr/share/pve-manager/js/dd_patcher.js 2>/dev/null  || echo N/A)\n"
        echo -e "PVE"
        echo -e "  Version:     $PVEVersion (major $PVEVersionMajor)\n"
        echo -e "Utility hash:  $(sha256sum $SCRIPTPATH 2>/dev/null  || echo N/A)"
        echo -e "Offline mode:  $OFFLINE"
    fi
    if isInstalled; then exit 0; else exit 1; fi
}

function install {
    if isInstalled; then
        if [ "$_silent" = false ]; then echo -e "${RED}Theme already installed${REG}"; fi
        exit 2
    else
        if [ "$_silent" = false ]; then checkSupported; fi

        if [ "$_silent" = false ]; then echo -e "${CHECKMARK} Backing up template file"; fi
        cp $TEMPLATE_FILE $TEMPLATE_FILE.bak

        if [ "$_silent" = false ]; then echo -e "${CHECKMARK} Downloading stylesheet"; fi

        if [ "$OFFLINE" = false ]; then
            curl -s $BASE_URL/PVEDiscordDark/sass/PVEDiscordDark.css > /usr/share/pve-manager/css/dd_style.css
        else
            cp "$OFFLINEDIR/PVEDiscordDark/sass/PVEDiscordDark.css" /usr/share/pve-manager/css/dd_style.css
        fi

        if [ "$_silent" = false ]; then echo -e "${CHECKMARK} Downloading patcher"; fi
        if [ "$OFFLINE" = false ]; then
            curl -s $BASE_URL/PVEDiscordDark/js/PVEDiscordDark.js > /usr/share/pve-manager/js/dd_patcher.js
        else
            cp "$OFFLINEDIR/PVEDiscordDark/js/PVEDiscordDark.js" /usr/share/pve-manager/js/dd_patcher.js
        fi

        if [ "$_silent" = false ]; then echo -e "${CHECKMARK} Applying changes to template file"; fi
        if !(grep -Fq "<link rel='stylesheet' type='text/css' href='/pve2/css/dd_style.css'>" $TEMPLATE_FILE); then
            echo "<link rel='stylesheet' type='text/css' href='/pve2/css/dd_style.css'>" >> $TEMPLATE_FILE
        fi 
        if !(grep -Fq "<script type='text/javascript' src='/pve2/js/dd_patcher.js'></script>" $TEMPLATE_FILE); then
            echo "<script type='text/javascript' src='/pve2/js/dd_patcher.js'></script>" >> $TEMPLATE_FILE
        fi 

        if [ "$OFFLINE" = false ]; then
            local IMAGELIST=$(curl -f -s "$BASE_URL/meta/imagelist")
        else 
            local IMAGELIST=$(cat "$OFFLINEDIR/meta/imagelist")
        fi

        local IMAGELISTARR=($(echo "$IMAGELIST" | tr ',' '\n'))
        if [ "$_silent" = false ]; then echo -e "Downloading images (0/${#IMAGELISTARR[@]})"; fi
        ITER=0
        for image in "${IMAGELISTARR[@]}"
        do
                if [ "$OFFLINE" = false ]; then
                    curl -s $BASE_URL/PVEDiscordDark/images/$image > /usr/share/pve-manager/images/$image
                else
                    cp "$OFFLINEDIR/PVEDiscordDark/images/$image" /usr/share/pve-manager/images/$image
                fi
                ((ITER++))
                if [ "$_silent" = false ]; then echo -e "\e[1A\e[KDownloading images ($ITER/${#IMAGELISTARR[@]})"; fi
        done
        if [ "$_silent" = false ]; then echo -e "\e[1A\e[K${CHECKMARK} Downloading images (${#IMAGELISTARR[@]}/${#IMAGELISTARR[@]})"; fi

        if [ "$_silent" = false ]; then echo -e "Theme installed."; fi
        if [ "$_noexit" = false ]; then exit 0; fi
    fi
}

function uninstall {
    if ! isInstalled; then
        echo -e "${RED}Theme not installed${REG}"
        exit 2
    else
        if [ "$_silent" = false ]; then echo -e "${CHECKMARK} Removing stylesheet"; fi
        rm /usr/share/pve-manager/css/dd_style.css

        if [ "$_silent" = false ]; then echo -e "${CHECKMARK} Removing patcher"; fi
        rm /usr/share/pve-manager/js/dd_patcher.js

        if [ "$_silent" = false ]; then echo -e "${CHECKMARK} Reverting changes to template file"; fi
        sed -i "/<link rel='stylesheet' type='text\/css' href='\/pve2\/css\/dd_style.css'>/d" /usr/share/pve-manager/index.html.tpl
        sed -i "/<script type='text\/javascript' src='\/pve2\/js\/dd_patcher.js'><\/script>/d" /usr/share/pve-manager/index.html.tpl

        if [ "$_silent" = false ]; then echo -e "${CHECKMARK} Removing images"; fi
        rm /usr/share/pve-manager/images/dd_*

        if [ "$_silent" = false ]; then echo -e "Theme uninstalled."; fi
        if [ "$_noexit" = false ]; then exit 0; fi
    fi
}

#endregion Main functions

_silent=false
_command=false
_noexit=false

parse_cli()
{
	while test $# -gt -0
	do
		_key="$1"
		case "$_key" in
			-h|--help)
				usage
				exit 0
				;;
            -s|--silent)
                _silent=true
                ;;
            status) 
                if [ "$_command" = false ]; then
                    _command=true
                    status
                fi
                ;;
            install) 
                if [ "$_command" = false ]; then
                    _command=true
                    install
                    exit 0
                fi
                ;;
            uninstall)
                if [ "$_command" = false ]; then
                    _command=true
                    uninstall
                    exit 0
                fi
                ;;
            update)
                if [ "$_command" = false ]; then
                    _command=true
                    _noexit=true
                    uninstall
                    install
                    exit 0
                fi
                ;;
	     *)
				echo -e "${BRED}Error: Got an unexpected argument \"$_key\"${REG}\n"; 
                usage;
                exit 1;
				;;
		esac
		shift
	done
}

parse_cli "$@"
