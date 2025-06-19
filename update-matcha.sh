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