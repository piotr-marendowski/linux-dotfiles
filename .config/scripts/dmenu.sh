#!/bin/sh
# dmenu with history in cache, option to translate using google translate
# run any commands in st and kill processes

# history
cachedir=${XDG_CACHE_HOME:-"$HOME/.cache"}
cache=$cachedir/dmenu_run
hist=$cachedir/dmenu_history
histsize=10

# make hist file if there isn't
if [ ! -e "$hist" ]; then
    touch "$hist"
fi

# dmenu_path
[ ! -e "$cachedir" ] && mkdir -p "$cachedir"

if stest -dqr -n "$cache" $PATH; then
	stest -flx $PATH | sort -u | tee "$cache"
else
	cat "$cache"
fi

# display dmenu with history and then rest of executables
cmd=$(
    awk -v histfile=$hist '
    BEGIN {
        while( (getline < histfile) > 0 ) {
            sub("^[0-9]+\t","")
            print
            x[$0]=1
        }
    } !x[$0]++ ' "$cache" \
    | dmenu "$@"
)

case $cmd in 
    # translate e.g. `en:es hello world` -> translate hello world to spanish
    *:* ) lang1=$(echo $cmd | cut -d':' -f1)
          lang2=$(echo $cmd | cut -d':' -f2 | cut -d' ' -f1)
          query=$(echo $cmd | cut -d':' -f2 | awk '{for(i=2;i<=NF;i++) print $i}') # get query after `es:en `
          query=$(echo $query | sed -E 's/\s{1,}/\+/g') # substitute spaces for `+`

          base_url="https://translate.googleapis.com/translate_a/single?client=gtx&sl=${lang1}&tl=${lang2}&dt=t&q="
          ua='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36'
          full_url=${base_url}${query}
          response=$(curl -sA "${ua}" "${full_url}")    # call api and get response

          translated=`echo ${response} | sed 's/","/\n/g' | sed -E 's/\[|\]|"//g' | head -1` # clean up the request
          echo $translated | dmenu
    ;;
    # translate only es -> en e.g. `/ hola mundo`
    \/* ) query=$(echo $cmd | cut -d':' -f2 | awk '{for(i=2;i<=NF;i++) print $i}') # get query after `/ `
          query=$(echo $query | sed -E 's/\s{1,}/\+/g') # substitute spaces for `+`

          base_url="https://translate.googleapis.com/translate_a/single?client=gtx&sl=es&tl=en&dt=t&q="
          ua='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36'
          full_url=${base_url}${query}
          response=$(curl -sA "${ua}" "${full_url}")

          translated=`echo ${response} | sed 's/","/\n/g' | sed -E 's/\[|\]|"//g' | head -1` # clean up the request
          echo $translated | dmenu
    ;;
    # run command e.g. `date!` -> open terminal with date
    *\! ) cmd=${cmd::-1}
          st -e sh -c "${cmd};exec $SHELL"

          # add cmd to history
          sed -i -e "/^${cmd}$/d;${histsize}q" "$hist"
          sed -i "1s/^/${cmd}\n/" "$hist"
    ;;
    # kill process e.g. `firefox~` -> kill firefox
    *~ )  cmd=${cmd::-1}; kill -9 $(pgrep -f ${cmd});;
    # run command normally
	* )   ${cmd}

          # add cmd to history
          sed -i -e "/^${cmd}$/d;${histsize}q" "$hist"
          sed -i "1s/^/${cmd}\n/" "$hist"
    ;;
esac

# delete empty lines if user aborts choosing
sed -i '/^\s*$/d' "$hist"

