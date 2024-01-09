#!/usr/bin/env bash
# Using gammastep for chaning Wayland brightness

kill -9 $(pgrep -f 'gammastep')
gammastep -l 0:0 -o -t 4500:4500 -b 0.75 &

