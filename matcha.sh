#!/bin/bash

#
#   READ ME !!!!!!!!!!!
#
#   The Base image being used is spiretf/docker-tf2-server and has been modified from spiretf/docker-comp-server
#   Credit: https://codeberg.org/spire/docker-comp-server
#
#   This shell script is also partly inspired by jsza's tempus docker startup script
#   It has been modified to fit matcha's on-demand container architecture rather than being persistent
#   Credit: https://github.com/jsza/docker-tempus-srcds/blob/master/run_tf2.sh
#
#   This image may also work on persistent machines, however is not our intended target
#

set -e

TF_DIR="$HOME/hlserver/tf2/tf"

# Bases
TF_CFG_DIR="$TF_DIR/cfg"

if [ ! -d "$TF_DIR/demos" ]; then
    mkdir $TF_DIR/demos
fi

# Sub directories for sourcemod
SM_DIR="$TF_DIR/addons/sourcemod"

SM_CONFIGS_DIR="$SM_DIR/configs"
SM_EXTENSIONS_DIR="$SM_DIR/extensions"
SM_GAMEDATA_DIR="$SM_DIR/gamedata"
SM_PLUGINS_DIR="$SM_DIR/plugins"
SM_TRANSLATIONS_DIR="$SM_DIR/translations"

# Customs
ROOT_MATCHA_REPO="$HOME/hlserver/matcha"
MATCHA_PLUGINS_REPO="$ROOT_MATCHA_REPO/matcha-tf2-plugins"
MATCHA_CFG_REPO="$ROOT_MATCHA_REPO/matcha-tf2-cfgs"

# Repository
GITHUB_USER="github-actions[bot]"
GIT_URL_PLUGINS="https://${GITHUB_USER}:${GH_PAT}@github.com/Matcha-Bookable/matcha-plugins-tf2.git"
GIT_URL_CFGS="https://${GITHUB_USER}:${GH_PAT}@github.com/Matcha-Bookable/matcha-cfgs-tf2.git"

# srctvplus (special cases)
cd $HOME/hlserver/tf2/tf/addons

wget -nv https://github.com/dalegaard/srctvplus/releases/download/v3.0/srctvplus.vdf
wget -nv https://github.com/dalegaard/srctvplus/releases/download/v3.0/srctvplus.so

# Pull all matcha's plugins
if [ ! -d $MATCHA_PLUGINS_REPO ]; then
    mkdir -p $MATCHA_PLUGINS_REPO
    git clone "$GIT_URL_PLUGINS" $MATCHA_PLUGINS_REPO
fi

# Pull all matcha's cfgs
if [ ! -d $MATCHA_CFG_REPO ]; then
    mkdir -p $MATCHA_CFG_REPO
    git clone "$GIT_URL_CFGS" $MATCHA_CFG_REPO
fi

# Maps
MAP_FILE="$MATCHA_CFG_REPO/comp/maps.txt"
MAP_DIR="$TF_DIR/maps"

# DLs
MATCHA_DL_URL="https://fastdl.avanlcy.hk"
SERVEME_DL_URL="https://fastdl.serveme.tf"

if [ -f "$MAP_FILE" ]; then
    if [[ ! -f "$MAP_FILE" ]]; then
            echo "MAP_FILE NOT FOUND, ${MAP_FILE}"
            exit 1
    fi

    while IFS= read -r map; do
            # Script always fails to retrieve the last line during build, we have to add a dummy line in the map file named "dummy"  (lol)
            if ! wget -nv -P "$MAP_DIR" "${MATCHA_DL_URL}/maps/${map}.bsp"; then
                echo "${map} not found on ${MATCHA_DL_URL}, trying ${SERVEME_DL_URL}..."
                if ! wget -nv -P "$MAP_DIR" "${SERVEME_DL_URL}/maps/${map}.bsp"; then
                    echo "Failed to download ${map}."
                fi
            fi
    done < "$MAP_FILE"
else
    echo "No maps.txt detected, terminating build process."
    exit 1
fi