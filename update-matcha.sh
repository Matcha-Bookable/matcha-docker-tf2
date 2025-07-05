#!/bin/bash

# Repository
GITHUB_USER="github-actions[bot]"
GIT_URL_PLUGINS="https://${GITHUB_USER}:${GH_PAT}@github.com/Matcha-Bookable/matcha-plugins-tf2.git"
GIT_URL_CFGS="https://${GITHUB_USER}:${GH_PAT}@github.com/Matcha-Bookable/matcha-cfgs-tf2.git"

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


#
#
#                               Compliance to ozfortress
#   This section will check the ISO3166-1 alpha-3 or IATA code of the instance name
#
# 
IPV4=$(curl -s https://api.ipify.org)

if [ -z "$MATCHA_API_KEY" ]; then
    echo "MATCHA_API_KEY environment variable not set. Exiting."
    exit 1
fi

# Extract instance prefix
RESPONSE=$(curl -s -X GET \
  -H "Authorization: Bearer $MATCHA_API_KEY" \
  "$MATCHA_API_DETAILS_URL/$IPV4")

INSTANCE=$(echo "$RESPONSE" | grep -o '"instance":"[^"]*"' | cut -d'"' -f4)
INSTANCE_PREFIX=$(echo "$INSTANCE" | cut -c1-3)

case "$INSTANCE_PREFIX" in
    syd|mel|per|nzl)
        echo "AU/NZ region detected ($INSTANCE_PREFIX). Running compliance script..."
        cd $SM_DIR/plugins
        
        if [ ! -f "ozf_bans.smx" ]; then
            wget -O ozf_bans.smx https://github.com/ozfortress/ozf-bans-enforcement/raw/refs/heads/main/plugins/ozf_bans.smx
        fi
        ;;
    *)
        echo "Non-AU/NZ region detected ($INSTANCE_PREFIX). Skipping compliance script."
        ;;
esac