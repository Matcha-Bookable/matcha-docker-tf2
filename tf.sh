#!/bin/sh
cd $HOME/hlserver

./update.sh
bash update-matcha.sh

# Taken from https://github.com/melkortf/tf2-servers/blob/master/packages/tf2-base/entrypoint.sh
quit() {
    echo "*** Stopping ***"
    exit 0
}

trap 'quit' SIGTERM

faketty() {
    # https://stackoverflow.com/questions/1401002/how-to-trick-an-application-into-thinking-its-stdout-is-a-terminal-not-a-pipe/60279429#60279429
    tmp=$(mktemp)
    [ "$tmp" ] || return 99
    cmd="$(printf '%q ' "$@")"'; echo $? > '$tmp
    script -qfc "/bin/sh -c $(printf "%q " "$cmd")" /dev/null
    [ -s $tmp ] || return 99
    err=$(cat $tmp)
    rm -f $tmp
    return $err
}

faketty tf2/srcds_run -game tf -autoupdate -steam_dir ~/hlserver -steamcmd_script ~/hlserver/tf2_ds.txt $@ & wait ${!}
