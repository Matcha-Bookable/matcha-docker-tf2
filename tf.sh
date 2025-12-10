#!/bin/sh
cd $HOME/hlserver

bash matcha-runner.sh

$SERVER/tf2/srcds_run -game tf -steam_dir ~/hlserver -steamcmd_script ~/hlserver/tf2_ds.txt $@