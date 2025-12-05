#!/bin/sh
cd $HOME/hlserver

bash matcha-runner.sh

trapped() {
    echo "- SIGTERM/SIGINT TRAPPED, uploading logs..."

    cd /home/tf2/hlserver/tf2/tf/logs

    # dump it all into our storage api
    for file in *; do
        if [ -f "$file" ]; then
            echo "Uploading log file...: $file"
            curl -X POST "https://storage.matcha-bookable.com/api/logs" \
                -F "bookingID=$BOOKINGID" \
                -F "file=@$file" \
                -H "Authorization: Bearer $MATCHA_API_KEY"
        fi
    done

    echo "Log upload completed"
    sleep 5
    exit 0
}

trap "trapped" SIGINT SIGTERM

tf2/srcds_run -game tf -steam_dir ~/hlserver -steamcmd_script ~/hlserver/tf2_ds.txt $@