#!/usr/bin/env bash

#wlr-randr --output DP-3 --mode 1920x1080 --pos 0,0 --output HDMI-A-1 --mode 1280x1024 --pos 1920,210
gammastep -l 0:0 -o -t 4500:4500 &
librewolf &
foot --server &
footclient -e tmux &
${XDG_CONFIG_HOME:-$HOME/.config}/scripts/trash.sh &
# bar for dwl
dwlb -font "FiraCode Nerd Font:size=11" \
     -hide-vacant-tags -active-fg-color "7f8490" \
     -active-bg-color "232428" \
     -occupied-bg-color "2c2e34" \
     -occupied-fg-color "7f8490" \
     -inactive-bg-color "2c2e34" \
     -inactive-fg-color "7f8490" \
     -urgent-bg-color "7f8490" \
     -urgent-fg-color "2c2e34" \
     -middle-bg-color-selected "232428" \
     -middle-bg-color "232428"
