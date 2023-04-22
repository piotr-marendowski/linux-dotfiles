#!/bin/bash
# Heavily modified version of script made by Derek Taylor (https://gitlab.com/dwt1)
# Author: Piotr Marendowski (https://github.com/piotr-marendowski), License: GPL3
#
# For more info on 'whiptail' see:
# https://en.wikibooks.org/wiki/Bash_Shell_Scripting/Whiptail
#
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

## Function with dependencies to all of the programs
dependencies() {
	dependencies_list=(wget curl ripgrep python-pip)
	
	# check if there is Paru on machine and install it if not
	# echo "Checking if there is Paru installed..."
	# if ! command -v paru -h &> /dev/null
	# then
	# 	echo "Paru could not be found"
	# 	echo "Proceeding to install Paru AUR helper..."
	# 	sudo pacman -S --needed base-devel
	# 	git clone https://aur.archlinux.org/paru.git
	# 	cd paru
	# 	makepkg -si
	# 	echo "done"
	# fi

	# add them to the programs array
	for element in "${dependencies_list[@]}"
	do
	  	programs+=("$element")
	done

	#echo "${dependencies_list[@]}"
	#echo "${programs[@]}"
}

## FOR EVERY FUNCTION BELOW:
# tag and descriptions --notags is used to only show descriptions
# newline character (\n) is for better placement
# don't know if it will be different on other monitors, but in mine it displays all equally
# third argument in dimensions = number of options
necessary() {
 	CHOICES=$(
		whiptail --title "System programs" --separate-output --checklist --notags \
		"\nPrograms used to achieve fully working modern system." 15 60 7 \
		"alacritty"      	"alacritty					  " OFF \
		"rofi" 				"rofi 						  " OFF \
		"dunst" 			"dunst	   				   	  " OFF \
		"flamshot" 			"flameshot					  " OFF \
		"gimp" 				"gimp   						  " OFF \
		"firefox" 			"firefox				                  " OFF \
		"htop" 				"htop  						  " OFF 3>&1 1>&2 2>&3
	)

	# add selected programs to the array
	for CHOICE in $CHOICES; do
		programs+=($CHOICE)
	done

	# print if nothing was selected
	if [ -z $CHOICE ]; then
	  	echo "No option was selected (user hit Cancel or unselected all options)"
	fi

	# mkdir -p ~/.config

	echo "${programs[@]}"
}

sound() {
 	CHOICES=$(
		whiptail --title "Sound" --separate-output --checklist --notags \
		"\nMusic makes sense when everything else is crazy." 15 60 7 \
		"alacritty"      	"alacritty					  " OFF \
		"rofi" 				"rofi 						  " OFF \
		"dunst" 			"dunst	   				   	  " OFF \
		"flamshot" 			"flameshot					  " OFF \
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

gui() {
 	CHOICES=$(
		whiptail --title "GUI" --separate-output --checklist --notags \
		'\n"Life is too short for ugly design." - Stefan Sagmeister' 15 60 7 \
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

# Menu window
menu() {
	# "4" "Make dotfiles"  \
	# "5" "Customize look and feel"  \
	# "6" "Install hardened Firefox profile"  \ 	# REMEMBER TO INCLUDE NOTE SECTION!
	# "7" "Optimize system for gaming"  \
	# "8" "Necessary packages"  \
	
	# newline character (\n) for better placement
	# we don't need to "set" shadow for every object as in radiolist
	CHOICE=$(
		whiptail --title "Install script" --menu "\nChoose one:" 15 60 8 \
		"1" " Full installation (all of them)                    "   \
		"2" " System programs"  \
		"3" " GUI"  \
		"4" " Sound"  \
		"9" " End script" 3>&2 2>&1 1>&3	
	)

	case $CHOICE in
		"1")   
			dependencies
			necessary
			gui
			sound
			;;
		"2")   
			necessary
			;;
		"3")   
			gui
			;;
		"4")   
			sound
			;;
		"9")
			exit
			;;
	esac
}

### PROGRAM EXECUTION
# Description
whiptail --title "Description" --msgbox "This install script requires an Arch-based machine with SystemD. \
For your own good configure sudo (with visudo) before. Better know what you are doing, because \
some options NOT selected will conclude in not fully working system!" 10 80

# Navigation
whiptail --title "Navigation" --msgbox "Navigate in lists by using arrows. Select options with space.  \
Use Tab key to navigate between the <Ok> and <Cancel> buttons." 8 80

# Menu
menu

# Necessary

# GUI

# Eye candy

# Sound

# Useful

# Other 

# Games

exit
