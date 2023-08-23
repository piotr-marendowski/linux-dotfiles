#!/bin/sh
# run commands in dmenu

termcmd="st -e" 
cmd="$(dmenu_path | dmenu -p "Run >" $@)" 
case $cmd in 
	*\! ) ${termcmd} "$(printf "%s" "${cmd}" | cut -d'!' -f1)";; 
	* ) ${cmd} ;; 
esac
exit
