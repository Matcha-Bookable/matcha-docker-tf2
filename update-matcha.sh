#!/bin/bash

# Repository
GITHUB_USER="github-actions[bot]"
GIT_URL_PLUGINS="https://${GITHUB_USER}:${GH_PAT}@github.com/Matcha-Bookable/matcha-plugins-tf2.git"
GIT_URL_CFGS="https://${GITHUB_USER}:${GH_PAT}@github.com/Matcha-Bookable/matcha-plugins-tf2.git"

# Directories
TF_DIR="$HOME/hlserver/tf2/tf"
SM_DIR="$TF_DIR/addons/sourcemod"
TF_CFG_DIR="$TF_DIR/cfg"
ROOT_MATCHA_REPO="$HOME/hlserver/matcha"
MATCHA_PLUGINS_REPO="$ROOT_MATCHA_REPO/matcha-plugins-tf2"
MATCHA_CFG_REPO="$ROOT_MATCHA_REPO/matcha-cfgs-tf2"

if [ -z "$GH_PAT" ]; then
    echo "GH_PAT environment variable not set. Exiting."
    exit 1
fi

cd "$MATCHA_PLUGINS_REPO"
git remote set-url origin "$GIT_URL_PLUGINS"
git pull

cd "$MATCHA_CFG_REPO"
git remote set-url origin "$GIT_URL_CFGS"
git pull

cp -rT $MATCHA_PLUGINS_REPO $SM_DIR
cp -rT $MATCHA_CFG_REPO $TF_CFG_DIR

# Maps
MAP_FILE="$TF_CFG_DIR/comp/maps.txt"
MAP_DIR="$TF_DIR/maps"

# DLs
MATCHA_DL_URL="https://fastdl.avanlcy.hk"
SERVEME_DL_URL="https://fastdl.serveme.tf"

# If map list were updated after image was built, we need to check the list with the map directory
if [ -f "$MAP_FILE" ]; then
    while IFS= read -r map; do
        map_file="$MAP_DIR/$map.bsp"
        if [ ! -f "$map_file" ]; then
            echo "$map not found, downloading from ${MATCHA_DL_URL}..."
            if ! wget -nv -P "$MAP_DIR" "${MATCHA_DL_URL}/maps/${line}.bsp"; then
                echo "${map} not found on ${MATCHA_DL_URL}, trying ${SERVEME_DL_URL}..."
                if ! wget -nv -P "$MAP_DIR" "${SERVEME_DL_URL}/maps/${map}.bsp"; then
                    echo "Failed to download ${map}."
                fi
            fi
        fi
    done < "$MAP_FILE"

    for map_file in "$MAP_DIR"/*.bsp; do
        map_name=$(basename "$map_file" .bsp)
        if ! grep -q "^$map_name$" "$MAP_FILE"; then
            echo "$map_name not listed, removing..."
            rm -f "$map_file"
        fi
    done

else
    echo "No maps.txt file found, skipping map updater"
fi