#!/bin/sh
# dmenu with history in cache, option to translate using google translate
# run any commands in st and kill processes
#
cachedir=${XDG_CACHE_HOME:-"$HOME/.cache"}
histsize=50
cache=$cachedir/dmenu
hist=$cachedir/dmenu_history

if [ ! -e "$hist" ]; then
    touch "$hist"
    echo foo
fi

cmd=$(
    IFS=:
        awk -v histfile=$hist '
        BEGIN {
            while( (getline < histfile) > 0 ) {
                sub("^[0-9]+\t","")
                print
                x[$0]=1
            }
        } !x[$0]++ ' "$cache" \
        | dmenu "$@"
        # (tac "$hist" ; stest -flx $PATH | sort -u | tee "$cache" ) | dmenu "$@"
    ) 

case $cmd in 
    # translate e.g. `en:es hello world` -> translate hello world to spanish
    *:* ) lang1=$(echo $cmd | cut -d':' -f1);
          lang2=$(echo $cmd | cut -d':' -f2 | cut -d' ' -f1);
          query=$(echo $cmd | cut -d':' -f2 | awk '{for(i=2;i<=NF;i++) print $i}'); # get query after `es:en `
          query=$(echo $query | sed -E 's/\s{1,}/\+/g'); # substitute spaces for `+`
          base_url="https://translate.googleapis.com/translate_a/single?client=gtx&sl=${lang1}&tl=${lang2}&dt=t&q="
          ua='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36'
          full_url=${base_url}${query}
          response=$(curl -sA "${ua}" "${full_url}")
          translated=`echo ${response} | sed 's/","/\n/g' | sed -E 's/\[|\]|"//g' | head -1` # clean up the request
          echo $translated | dmenu;;
    # run command e.g. `date!` -> open terminal with date
    *\! ) cmd=$(printf "%s" "${cmd}" | cut -d'!' -f1);
          st -e sh -c "${cmd};exec $SHELL";

          # add cmd to history
          sed -i -e "/^${cmd}$/d;${histsize}q" "$hist";
          sed -i "1s/^/${cmd}\n/" "$hist" ;;
    # kill process e.g. `firefox~` -> kill firefox
    *~ )  cmd=$(printf "%s" "${cmd}" | cut -d'~' -f1); kill -9 $(pgrep -f ${cmd});;
	* )   ${cmd};

          # add cmd to history
          sed -i -e "/^${cmd}$/d;${histsize}q" "$hist";
          sed -i "1s/^/${cmd}\n/" "$hist" ;;
esac


