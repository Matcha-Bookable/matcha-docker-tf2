#!/bin/sh
cd $HOME/hlserver

./update.sh
bash update-matcha.sh

tf2/srcds_run -game tf -autoupdate -steam_dir ~/hlserver -steamcmd_script ~/hlserver/tf2_ds.txt $@