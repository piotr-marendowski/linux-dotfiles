#!/bin/bash
# Heavily modified version of script made by Derek Taylor (https://gitlab.com/dwt1)
# Author: Piotr Marendowski (https://github.com/piotr-marendowski), License: GPL3
#
# For more info on 'whiptail' see:
#https://en.wikibooks.org/wiki/Bash_Shell_Scripting/Whiptail
#
# WORK IN PROGRESS!!
# Steps of making this script:
# 1. Porting the old one to this
# 2. Decentralizing big parts into lists
# 3. Adding new content/fixing bugs

# These exports are the only way to specify colors with whiptail.
# See this thread for more info:
# https://askubuntu.com/questions/776831/whiptail-change-background-color-dynamically-from-magenta/781062
export NEWT_COLORS="
root=,black
window=,black
shadow=,black
border=white,black
title=white,black
textbox=white,black
radiolist=black,black
label=black,white
checkbox=black,white
compactbutton=black,white
button=black,red"

# Array of programs to install
programs=()

gui() {
	# tag and descriptions --notags is used to only show descriptions
	CHOICES=$(
		whiptail --title "GUI" --separate-output --checklist --notags "Choose one or more options:" 15 60 7 \
		"xorg"      		"xorg						  " OFF \
		"xorg-xinit" 		"xorg-xinit					  " OFF \
		"playerctl" 		"playerctl					  " OFF \
		"qtile-git" 		"qtile-git					  " OFF \
		"qtile-extras-git" 	"qtile-extras-git				  " OFF \
		"ly" 				"ly						  " OFF \
		"gsimplecal" 		"gsimplecal			          	  " OFF 3>&1 1>&2 2>&3
	)

	# add selected programs to the array
	for CHOICE in $CHOICES; do
		programs+=($CHOICE)
	done

	# print if nothing was selected
	if [ -z $CHOICE ]; then
	  	echo "No option was selected (user hit Cancel or unselected all options)"
	fi

	echo "${programs[@]}"
}

## Configure installed packages
configure_installed() {
	# Alacritty
	if command -v alacritty -h &> /dev/null
	then
		mkdir -p ~/.config/alacritty
		cp /usr/share/doc/alacritty/example/alacritty.yml ~/.config/alacritty/alacritty.yml
	fi

	# Dunst
	if command -v dunst -h &> /dev/null
	then
		mkdir -p ~/.config/dunst
		cp /etc/dunst/dunstrc ~/.config/dunst/dunstrc
	fi

	# Rofi
	if command -v rofi -h &> /dev/null
	then
		mkdir -p ~/.config/rofi
		rofi -dump-config > ~/.config/rofi/config.rasi
		cp $dir/rofi/simple-tokyonight.rasi ~/.config/rofi/simple-tokyonight.rasi
	fi

	# Firefox - install hardened profile, which will need to be changed manually!
	if command -v firefox -h &> /dev/null
	then
		local profile_name=profile1
		firefox -CreateProfile "$profile_name" && firefox -P "$profile_name" -no-remote
		cd ~/.mozilla/firefox/*$profile_name*/
		cp $dir/firefox/prefs.js /prefs.js
	fi
}

# Menu window
menu() {
	# Only for "debugging" purposes
	while [ 1 ]
	do
	CHOICE=$(
	whiptail --title "Install script" --menu "Choose one:" 16 90 9 \
		"1)" "Full installation (all of them)"   \
		"2)" "Install necessary packages"  \
		"2)" "Install GUI"  \
		"2)" "Make dotfiles"  \
		"2)" "Customize look and feel"  \
		"2)" "Install hardened Firefox profile"  \ 	# REMEMBER TO INCLUDE NOTE SECTION!
		"2)" "Optimize system for gaming"  \
		"2)" "Necessary packages"  \
		"2)" "Necessary packages"  \
		"9)" "End script"  3>&2 2>&1 1>&3	
	)

	case $CHOICE in
		"1)")   
			break
		;;
		"2)")   
			result="This system has been up $OP minutes"
		;;
		"9)") exit
			;;
	esac
	done
}

### PROGRAM EXECUTION
# Hello window
whiptail --title "Install script" --msgbox "This install script requires an Arch-based machine with SystemD. \
For your own good configure sudo (with visudo) before. Use TAB for navigation in <Ok> and <Cancel> options. \
After this window will you will be prompted to install Paru - AUR helper which is used to download every program. \
Better know what you are doing, because some options NOT selected will conclude in not fully working system!" 11 100

# Menu
#menu
gui

# Necessary
install "Web Browsers" "Select one or more options.\n" \
"firefox" "chromium" "brave" "librewolf" "qutebrowser"

# # GUI
# install "GUI" "Select one or more options.\n" \
# "xorg" "xorg-xinit" "playerctl" "qtile-git" "qtile-extras-git" "ly" "gsimplecal"

# # Eye candy
# install "Eye candy" "Select one or more options.\n" \
# "papirus-icon-theme" "lxappearance" "nitrogen" "gtk4" "gtk3" "redshift"

# Sound
#install "Sound" "Select one or more options.\n" \
#"" ""

# Useful
#install "More useful" "Select one or more options.\n" \
#"alacritty" "dunst" "rofi" "htop" "flameshot" ""

# Other 
# install "Other" "Select one or more options.\n" \
# "discord-canary" "spotify" "libreoffice-fresh"

# Games
#install "Gaming" "steam" "lutris" "mangohud" ""

exit
