#!/bin/bash 

ls -l $SERVER
ls -l /home/tf2/hlserver/tf2
cd $SERVER/tf2/tf/maps

rm -f *.bsp || true

cd $SERVER/tf2/tf

rm -f resource/tf_*.txt || true