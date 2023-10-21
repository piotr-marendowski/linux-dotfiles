#!/bin/sh
# en:es hello -> translate hello to spanish (using https://github.com/soimort/translate-shell/)
# date! -> open terminal with date
# librewolf~ -> kill librewolf

cmd="$(dmenu_path | dmenu -p ">" $@)" 
case $cmd in 
    *:* ) gawk -f <(curl -Ls --compressed https://git.io/translate) ${cmd} | sed -n '3,4p' | sed 's/.*m\(.*\)\[.*/\1/' | dmenu;;
    *\! ) cmd=$(printf "%s" "${cmd}" | cut -d'!' -f1);
          st -e sh -c "${cmd};exec $SHELL";; 
    *~ )  cmd=$(printf "%s" "${cmd}" | cut -d'~' -f1); kill -9 $(pgrep -f ${cmd});;
	* )   ${cmd} ;; 
esac

