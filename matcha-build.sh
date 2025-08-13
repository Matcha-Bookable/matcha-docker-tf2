#!/bin/bash

# This shell script contains the modified base for Matcha Bookable's Image
# To actually run the image, you will need RO PAT from Matcha Bookable

set -e

TF_DIR="$HOME/hlserver/tf2/tf"

# Demos and CFG directories
mkdir $TF_DIR/demos
TF_CFG_DIR="$TF_DIR/cfg"

# Customs
ROOT_MATCHA_REPO="$HOME/hlserver/matcha"
MATCHA_PLUGINS_REPO="$ROOT_MATCHA_REPO/matcha-plugins-tf2"
MATCHA_CFG_REPO="$ROOT_MATCHA_REPO/matcha-cfgs-tf2"

# Repository
GITHUB_USER="github-actions[bot]"
GIT_URL_PLUGINS="https://${GITHUB_USER}:${GH_PAT}@github.com/Matcha-Bookable/matcha-plugins-tf2.git"
GIT_URL_CFGS="https://${GITHUB_USER}:${GH_PAT}@github.com/Matcha-Bookable/matcha-cfgs-tf2.git"

###################         
#     Plugins     #
###################

# --------------- #
# SourcebansPP
cd $HOME/hlserver/tf2/tf
wget -nv https://github.com/sbpp/sourcebans-pp/releases/download/Plugins-Latest/sourcebans-pp-Plugins-Latest.tar.gz
tar -xf sourcebans-pp-Plugins-Latest.tar.gz --strip-components 1
rm sourcebans-pp-Plugins-Latest.tar.gz

# SOAP-DM (sapphonie/SOAP-TF2DM)
wget -nv "https://github.com/sapphonie/SOAP-TF2DM/archive/master.zip" -O "soap-dm.zip"
unzip -o soap-dm.zip
cp -r SOAP-TF2DM-master/* ./
rm -r SOAP-TF2DM-master
rm soap-dm.zip

# tf2-comp-fixes (ldesgoui/tf2-comp-fixes)
wget -nv https://github.com/ldesgoui/tf2-comp-fixes/releases/download/v1.16.19/tf2-comp-fixes.zip
unzip -o tf2-comp-fixes.zip
rm tf2-comp-fixes.zip

# Custom-votes-redux (axanga334/cvreduxmodified)
wget -nv https://github.com/caxanga334/cvreduxmodified/releases/download/1.19.4a/cvredux-1.11.x-924ba39.zip
unzip -o cvredux-1.11.x-924ba39.zip
rm cvredux-1.11.x-924ba39.zip

# --------------- #
# srctvplus (dalegaard/srctvplus)
cd $HOME/hlserver/tf2/tf/addons

wget -nv https://github.com/dalegaard/srctvplus/releases/download/v3.0/srctvplus.vdf
wget -nv https://github.com/dalegaard/srctvplus/releases/download/v3.0/srctvplus.so

# --------------- #
# Enchanced-Match-Timer (ozfortress/Enhanced-Match-Timer)
cd $HOME/hlserver/tf2/tf/addons/sourcemod

wget -nv "https://github.com/ozfortress/Enhanced-Match-Timer/releases/download/v1.5.2/enhanced_match_timer.zip"
unzip -o enhanced_match_timer.zip
rm enhanced_match_timer.zip

# DemoCheck (ozfortress/demo_check_plugin)
wget -nv https://github.com/ozfortress/demo_check_plugin/releases/download/v2.0.0/demo_check.zip
unzip -o demo_check.zip
rm demo_check.zip
rm $HOME/hlserver/tf2/tf/addons/sourcemod/plugins/demo_check_no_discord.smx

# StAC-tf2 (sapphonie/StAC-tf2)
wget -nv https://github.com/sapphonie/StAC-tf2/releases/download/v6.3.7/stac.zip
unzip -o stac.zip
rm stac.zip

# --------------- #
# F2s (F2/F2s-sourcemod-plugins)
cd $HOME/hlserver/tf2/tf/addons/sourcemod/plugins

wget -nv  --header="Accept: text/html" --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" "http://sourcemod.krus.dk/f2-sourcemod-plugins.zip"
unzip -o f2-sourcemod-plugins.zip
rm f2-sourcemod-plugins.zip

# DemosTF (demostf/plugin)
wget -nv https://github.com/demostf/plugin/raw/master/demostf.smx

# ProperPregame (AJagger/ProperPregame)
wget -nv https://github.com/AJagger/ProperPregame/raw/master/addons/sourcemod/plugins/properpregame.smx

# MapDownloader (spiretf/mapdownloader)
wget -nv https://github.com/spiretf/mapdownloader/raw/master/plugin/mapdownloader.smx

# WhitelistDownloader (spiretf/sm_whitelist)
wget -nv https://github.com/spiretf/sm_whitelist/raw/master/plugin/whitelisttf.smx

chmod 0664 *.smx

# Dependecies

# SteamWorks (KyleSanderson/SteamWorks)
cd $HOME/hlserver/tf2/tf
wget -nv "https://github.com/KyleSanderson/SteamWorks/releases/download/1.2.3c/package-lin.tgz" -O "steamworks.tar.gz"
tar -xf steamworks.tar.gz --strip-components 1
rm steamworks.tar.gz

# neocurl (sapphonie/SM-neocurl-ext)
cd $HOME/hlserver/tf2/tf/addons/sourcemod
wget -nv "https://github.com/sapphonie/SM-neocurl-ext/releases/download/v2.0.0-beta/sm-neocurl.zip"
unzip -o sm-neocurl.zip
rm sm-neocurl.zip


# CLEAN UP
rm -rf $HOME/hlserver/tf2/tf/addons/sourcemod/scripting/*
rm -rf $HOME/hlserver/tf2/tf/addons/sourcemod/scriptings/*

rm -f $HOME/hlserver/tf2/tf/addons/sourcemod/plugins/nextmap.smx \
	  $HOME/hlserver/tf2/tf/addons/sourcemod/plugins/funcommands.smx \
	  $HOME/hlserver/tf2/tf/addons/sourcemod/plugins/funvotes.smx

# We also don't need any cfg since we provide it in runtime
rm -rf $HOME/hlserver/tf2/tf/cfg/*