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

# colors
export NEWT_COLORS="
root=,black
window=black,black
shadow=black,black
border=white,black
title=white,black
textbox=white,black
radiolist=white,black
label=black,white
checkbox=white,black
compactbutton=black,white
listbox=white,black
button=black,red"

# dotfolders directory
dir=~/.dotfiles
# old dotfolders backup directory
olddir=~/.dotfiles_old 
# create arrays for: folders/normal files, hidden files, and excluded characters/files
folders=(*)
files=(.*)
exclude=(. ..)
exclude_files=(firefox script.sh README.md LICENSE .git)

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

	# Xorg
	if command -v X -version &> /dev/null
	then
		echo "Configuring Xorg server and adding Qtile as default window manager..."
		cp /etc/X11/xinit/xinitrc ~/.xinitrc && echo "(1/4)"
		head -n -5 .xinitrc > .xinitrc-temp && mv .xinitrc-temp .xinitrc && echo "(2/4)"
		echo exec qtile start >> ~/.xinitrc && echo "(3/4)"
		rm ~/.xinitrc-new && echo "(4/4)"
		echo "done"
	fi
	
	pip install dbus-next
	pip install pyxdg

	echo "Customizing theme..."
	sudo cp $dir/assets/TokyoNight /usr/share/themes/
	echo "done"

	echo "Installing custom Picom compositor..."
	paru -S picom-jonaburg-git
	echo "done"

	echo "Setting wallpaper..."
	nitrogen --set-zoom-fill $dir/assets/wallpaper.jpg
	echo "done"
}

## Function with dependencies to all of the programs
dependencies() {
	dependencies_list=(wget curl ripgrep python-pip meson ninja)
	
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
	#--notags
 	CHOICES=$(
		whiptail --title "System programs" --checklist --notags --separate-output\
		"\nPrograms used to achieve fully working modern system." 16 60 8 \
		"alacritty"      	"alacritty" OFF \
		"rofi" 				"rofi"  OFF \
		"dunst" 			"dunst" OFF \
		"flamshot" 			"flameshot" OFF \
		"gimp" 				"gimp" OFF \
		"firefox" 			"firefox" OFF \
		"neovim" 			"neovim" OFF \
		"htop" 				"htop" OFF 3>&1 1>&2 2>&3
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
		"\nMusic makes sense when everything else is crazy." 16 60 8 \
		"pulseaudio"      	"pulseaudio					  " OFF \
		"pavucontrol" 		"pavucontrol 				          " OFF \
		"alsa-utils" 		"alsa-utils	   				  " OFF \
		"pipewire" 			"pipewire	   				  " OFF \
		"pipewire-audio" 	"pipewire-audio		     		          " OFF \
		"pipewire-alsa" 	"pipewire-alsa                  		          " OFF \
		"pipewire-pulse" 	"pipewire-pulse           		       	  " OFF \
		"pipewire-jack" 	"pipewire-jack                       		  " OFF 3>&1 1>&2 2>&3
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
		$'\nThe best GUI is the one you don\'t notice.' 15 60 7 \
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

# customize GTK and QT themes
look_and_feel() {
	CHOICES=$(
		whiptail --title "Look and feel" --separate-output --checklist --notags \
		'\n"Life is too short for ugly design." - Stefan Sagmeister' 11 60 3 \
		"lxappearance"     		"lxappearance				          " OFF \
		"papirus-icon-theme"	"papirus-icon-theme			          " OFF \
		"picom-jonaburg-git" 	"picom-jonaburg-git			          " OFF 3>&1 1>&2 2>&3
	)

	# add selected programs to the array
	for CHOICE in $CHOICES; do
		programs+=($CHOICE)
	done

	# print if nothing was selected
	if [ -z $CHOICE ]; then
	  	echo "No option was selected (user hit Cancel or unselected all options)"
	fi

	# configure fonts
	CHOICE=$(
		whiptail --title "Fonts" --notags --menu "\nA font is a tool, not a decoration." 11 60 2 \
			"1" "Full Nerd Fonts (~3.5 GB)"   \
			"2" "JetBrainsMono font only (~30 MB)" 3>&2 2>&1 1>&3	
	)

	case $CHOICE in
		"1")   
			#paru -S nerd-fonts-meta
			;;
		"2")   
			#mkdir -p ~/.local/share/fonts
			#cp -r $dir/assets/JetBrainsMono ~/.local/share/fonts
			;;
	esac

	echo "${programs[@]}"

}

gaming() {
	whiptail --title "Warming" --yesno "Before installing and configuring system for \
	gaming, first you need to enable Multilib in pacman.conf in order to install 32 bit drivers. \
	Do you want to do it now?" 9 80
	
	if [ $? -eq 0 ]; then
		sudo nvim /etc/pacman.conf
	fi

	CHOICES=$(
		whiptail --title "Gaming" --separate-output --checklist --notags \
		"\nThe game is never over, unless you stop playing." 21 60 13 \
		"steam"      				"steam						  " OFF \
		"lutris"      				"lutris						  " OFF \
		"wine-staging"      		"wine-staging		     		  	  " OFF \
		"nvidia"      				"nvidia						  " OFF \
		"nvidia-dkms" 				"nvidia-dmks 				  	  " OFF \
		"nvidia-utils" 				"nvidia-utils			   	  	  " OFF \
		"lib32-nvidia-utils" 		"lib32-nvidia-utils			  	  " OFF \
		"nvidia-settings" 			"nvidia-settings			  	          " OFF \
		"vulkan-icd-loader" 		"vulkan-icd-loader	 		 	  " OFF \
		"lib32-vulkan-icd-loader" 	"lib32-vulkan-icd-loader	  	                  " OFF \
		"proton-ge-custom" 			"proton-ge-custom			  	  " OFF \
		"mangohud-git" 				"mangohud-git			  		  " OFF \
		"goverlay-bin" 				"goverlay-bin			  	          " OFF 3>&1 1>&2 2>&3
	)

	# echo "Installing GreenWithEnvy"
	# cd ~/Downloads
	# git clone --recurse-submodules -j4 https://gitlab.com/leinardi/gwe.git
	# cd gwe
	# git checkout release
	# sudo -H pip3 install -r requirements.txt
	# meson . build --prefix /usr
	# ninja -v -C build
	# sudo ninja -v -C build install
	# echo "done"

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

## DOTFILES
make_dotfiles() {
	echo "Searching $dir directory..."
	# search for folders (and not hidden files)
	for i in ${folders[@]}; do
		:
	done
	# search for all hidden files (even something like '.' and '..')
	for i in ${files[@]}; do
		:
	done
	# exclude weird characters from files array
	for char in "${exclude[@]}"; do
		for i in "${!files[@]}"; do
			if [[ ${files[i]} = $char ]]; then
				unset 'files[i]'
			fi
		done
	done
	# exclude not-dotfolders/not-dotfiles
	for del in ${exclude_files[@]}
	do
		folders=("${folders[@]/$del}") 	#Quotes when working with strings
	done
	for del in ${exclude_files[@]}
	do
		files=("${files[@]/$del}") 	#Quotes when working with strings
	done
	echo "done"

	echo "Folders/files in $dir: ${folders[@]}"
	echo "Hidden files in $dir: ${files[@]}"

	# create dotfolders_old in homedir
	echo "Creating $olddir for backup of any existing dotfolders in ~..."
	mkdir -p $olddir
	echo "done"

	# enter dotfolder in order to process only files in it and not files in homedir
	echo "Entering $dir..."
	cd $dir
	echo "done"

	# Move any dotfile "listed" (present) in dir to olddir and create a symlink from
	# "listed" file to this file in homedir
	echo "Moving any existing dotfolders from ~ to $olddir..."
	echo "DON'T PANIC IF THERE ARE ERRORS!"
	# folders/normal files
	for file in ${folders[@]}; do
		mv ~/$file $olddir
		echo "Creating symlink to $file in home directory..."
		ln -s $dir/$file ~/$file
	done
	# hidden files
	for file in ${files[@]}; do
		mv ~/$file $olddir
		echo "Creating symlink to $file in home directory..."
		ln -s $dir/$file ~/$file
	done
	echo "done"

	clear
	echo "Dotfiles made."
}

install() {
	whiptail --title "Warming" --yesno "Do you want to install selected programs?" 7 45
	
	if [ $? -eq 0 ]; then
		echo "Installing selected programs..."
		# Check if paru is installed
		if ! command -v paru &> /dev/null; then
			echo "Paru is not installed. Installing it..."
			sudo pacman -S --needed base-devel
			git clone https://aur.archlinux.org/paru.git
			cd paru
			makepkg -si
			echo "done"
		fi

		# Loop through the program names array and install each program using paru
		# --noconfirm to automatically say yes to every installation
		for program in "${@}"; do
			paru -S --noconfirm "$program"
		done
		  
		whiptail --title "Info" --infobox "Installation successful.\
		Do you want to do it now?" 9 80
	fi

	menu
}

# Menu window
menu() {
	# "7" "Optimize system for gaming"  \
	
	# newline character (\n) for better placement
	# we don't need to "set" shadow for every object as in radiolist
	CHOICE=$(
		whiptail --title "Menu" --cancel-button "Exit" --notags --menu "" 15 60 8 \
		"1" "Full installation (all of them)"  \
		"2" "System programs"  \
		"3" "GUI"  \
		"4" "Sound"  \
		"5" "Look and feel"  \
		"6" "Gaming"  \
		"7" "Install selected programs"  \
		"8" "End script" 3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
			dependencies
			necessary
			gui
			look_and_feel
			sound
			gaming
			# make_dotfiles
			install "${programs[@]}"
			# configure_installed
			exit
			;;
		"2")   
			necessary
			menu
			;;
		"3")   
			gui
			menu
			;;
		"4")   
			sound
			menu
			;;
		"5")   
			look_and_feel
			menu
			;;
		"6")   
			gaming
			menu
			;;
		"7")   
			install "${programs[@]}"
			;;
		"8")
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
whiptail --title "Navigation" --msgbox "Navigate in lists by using arrow keys. \
Select options with space. Use Tab key to navigate between the <Ok> and <Cancel> buttons." 8 80

# Menu
menu

exit
