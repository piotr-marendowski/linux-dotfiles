#!/usr/bin/env bash

selected="$(ps -a -u $USER | \
            dmenu -l 7 -fn "JetBrainsMono Nerd Font:size=15" | \
            awk '{print $1" "$4}')"; 

selpid="$(awk '{print $1}' <<< $selected)"; 
kill -9 $selpid

exit 0
