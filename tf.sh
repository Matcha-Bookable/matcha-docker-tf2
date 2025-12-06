#!/bin/sh
cd $HOME/hlserver

bash matcha-runner.sh

# This create a webhook server for our backend to communicate with the server
# Tried netcat, can't format text in HTTP/1.1 format for some reason
# REASON for change: The old method of uploading via SIGTERM isn't consistent enough
python3 $SERVER/webhook_server.py &

tf2/srcds_run -game tf -steam_dir ~/hlserver -steamcmd_script ~/hlserver/tf2_ds.txt $@