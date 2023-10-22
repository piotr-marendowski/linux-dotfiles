#!/bin/sh

cmd="$(dmenu_path | dmenu -p ">" $@)" 
case $cmd in 
    # translate e.g. en:es hello -> translate hello to spanish
    *:* ) lang1=$(echo $cmd | cut -d':' -f1);
          lang2=$(echo $cmd | cut -d':' -f2 | cut -d' ' -f1);
          query=$(echo $cmd | cut -d':' -f2 | cut -d' ' -f2);
          base_url="https://translate.googleapis.com/translate_a/single?client=gtx&sl=${lang1}&tl=${lang2}&dt=t&q="
          ua='Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36'
          full_url=${base_url}"${query}"
          response=$(curl -sA "${ua}" "${full_url}")
          translated=`echo ${response} | sed 's/","/\n/g' | sed -E 's/\[|\]|"//g' | head -1`
          echo $translated | dmenu;;
    # run command e.g. date! -> open terminal with date
    *\! ) cmd=$(printf "%s" "${cmd}" | cut -d'!' -f1);
          st -e sh -c "${cmd};exec $SHELL";; 
    # kill process e.g. librewolf~ -> kill librewolf
    *~ )  cmd=$(printf "%s" "${cmd}" | cut -d'~' -f1); kill -9 $(pgrep -f ${cmd});;
	* )   ${cmd} ;; 
esac

