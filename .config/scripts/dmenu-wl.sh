#!/usr/bin/env bash

shopt -s expand_aliases
alias dmenu_program='dmenu-wl -p ">" -fn "FiraCode Nerd Font" -nb "#2c2e34" -nf "#7f8490" -sb "#2c2e34" -sf "#76cce0"'
alias terminal='footclient'
# history
cachedir=${XDG_CACHE_HOME:-"$HOME/.cache"}
cache=$cachedir/dmenu_run
hist=$cachedir/dmenu_history
histsize=30

# update the list of executables
IFS=:
stest -flx $PATH | sort -u | tee "$cache"

# display dmenu-wl with history and then rest of executables
cmd=$(cat "$hist" "$cache" | awk '!seen[$0]++' | dmenu_program)

case $cmd in 
    # translate e.g. `en:es hello world` -> translate hello world to spanish
    *:* ) lang1=$(echo $cmd | awk '{print $1;}')
          lang2=$(echo $cmd | awk '{print $2;}')
          query=${cmd#*$lang2 }                                 # get query after `es:en `
          query=$(echo "${query}" | sed -E 's/\s{1,}/\+/g')     # substitute spaces for `+`

          base_url="https://translate.googleapis.com/translate_a/single?client=gtx&sl=${lang1}&tl=${lang2}&dt=t&q="
          ua='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36'
          full_url=${base_url}${query}
          response=$(curl -sA "${ua}" "${full_url}")            # call api and get response

          translated=`echo ${response} | sed 's/","/\n/g' | sed -E 's/\[|\]|"//g' | head -1` # clean up the request
          echo $translated | dmenu_program
    ;;
    # translate only es -> en e.g. `/ hola mundo`
    \/* ) query=${cmd#*/ }                                      # get query after `/ `
          query=$(echo $query | sed -E 's/\s{1,}/\+/g')         # substitute spaces for `+`

          base_url="https://translate.googleapis.com/translate_a/single?client=gtx&sl=es&tl=en&dt=t&q="
          ua='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36'
          full_url=${base_url}${query}
          response=$(curl -sA "${ua}" "${full_url}")

          translated=`echo ${response} | sed 's/","/\n/g' | sed -E 's/\[|\]|"//g' | head -1` # clean up the request
          echo $translated | dmenu_program
    ;;
    # run command e.g. `date!` -> open terminal with date
    *\! ) cmd=${cmd::-1}
          terminal -e sh -c "${cmd};exec $SHELL"

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
