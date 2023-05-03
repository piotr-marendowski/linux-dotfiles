#!/bin/bash
# Heavily modified version of script made by Derek Taylor (https://gitlab.com/dwt1)
# Author: Piotr Marendowski (https://github.com/piotr-marendowski), License: GPL3
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
exclude_files=(assets firefox script.sh whiptail-script.sh README.md LICENSE .git)

# Array of programs to install
programs=()

## Configure installed packages
configure_installed() {

	mkdir -p ~/.config

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

	# theme
	sudo cp $dir/assets/TokyoNight /usr/share/themes/

	if command -v nitrogen -h &> /dev/null
	then
		echo "Setting wallpaper..."
		nitrogen --set-auto $dir/assets/wallpaper.jpg
		echo "done"
	fi

	# make dotfiles
	echo "Searching $dir directory..."
	# search for folders (and not hidden files)
	for i in ${folders[@]}; do
		:
	done
	# search for all hidden files (even something like '.' and '..')
	for i in ${files[@]}; do
		:
	done
	# exclude some files and directories from files array
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
		folders=("${folders[@]/$del}") 		# Quotes when working with strings
	done
	for del in ${exclude_files[@]}
	do
		files=("${files[@]/$del}") 			# Quotes when working with strings
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

	# Move any dotfile "listed" (present) in dir to olddir and move a file from this
	# repo to program's directory e.g. ~/.config
	echo "Moving any existing dotfolders from ~ to $olddir..."
	echo "DON'T PANIC IF THERE ARE ERRORS!"
	# folders/normal files
	for file in ${folders[@]}; do
		mv ~/$file $olddir
		echo "Moving $file to homedir..."
		cp -rf $dir/$file ~/$file
	done
	# hidden files
	for file in ${files[@]}; do
		mv ~/$file $olddir
		echo "Moving $file to homedir..."
		cp -rf $dir/$file ~/$file
	done
	echo "done"

	# virtualization
	whiptail --title "VIRTUALIZATION: Warming" --yesno "You need to ensure that these are set to: \
unix_sock_group = \"libvirt\", unix_sock_ro_perms = \"0777\", and unix_sock_rw_perms = \"0770\". \
Do you want to do it now?" 10 80
	
	if [ $? -eq 0 ]; then
		sudo nvim /etc/libvirt/libvirtd.conf
	fi

	if systemctl status libvirtd; then
		local user_name=$(whoami)
		sudo usermod -aG libvirt $user_name
		sudo systemctl enable libvirtd
		sudo systemctl restart libvirtd
	else
		echo "libvirt is not installed"
	fi

	# login managers - check if pacman -Q name begins with name of the login manager
	# and enable its service if it is
	echo "Proceeding to check if login manager is installed..."
	# if ly is installed
	pacman -Q ly | grep -q "^ly" && sudo systemctl enable ly && echo "Ly installed."
	# if sddm is installed - customize it
	if pacman -Q sddm | grep -q "^sddm"; then
		sudo systemctl enable sddm
		echo "Sddm installed."
		sudo cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf

		# install theme
		git clone https://github.com/rototrash/tokyo-night-sddm.git ~/tokyo-night-sddm
		sudo mv ~/tokyo-night-sddm /usr/share/sddm/themes/

		# edit /etc/sddm.conf
		# read the contents of line 31 into a variable
		line31=$(sed -n '31p' /etc/sddm.conf)
		# check if the contents of line 31 match
		if [[ "$line31" == *"[Theme]"* ]]; then
			# if the pattern is matched, replace the line 33 with a theme name
			sed -i '33s/.*/Current=tokyo-night-sddm/' /etc/sddm.conf
		fi
	fi
}

## Function with dependencies to all of the programs
dependencies() {
	dependencies_list=(wget curl ripgrep python-pip meson ninja)

	mkdir -p ~/Downloads
	
	# check if there is Paru on machine and install it if not
	echo "Checking if there is Paru installed..."
	if ! command -v paru -h &> /dev/null
	then
		echo "Paru could not be found"
		echo "Proceeding to install Paru AUR helper..."
		sudo pacman -S --needed base-devel
		cd ~/Downloads
		git clone https://aur.archlinux.org/paru.git
		cd paru
		makepkg -si
		echo "done"
	fi

	# add them to the programs array
	programs+=( "${dependencies_list[@]}" )
}

## FOR EVERY FUNCTION BELOW:
# tag and descriptions --notags is used to only show descriptions
# newline character (\n) is for better placement
# don't know if it will be different on other monitors, but in mine it displays all equally
# third argument in dimensions = number of options
necessary() {
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

	echo "${programs[@]}"
}

sound() {
	CHOICE=$(
		whiptail --title "Menu" --cancel-button "Exit" --notags --menu \
		"\nMusic makes sense when everything else is crazy." 12 60 3 \
		"1" "Pipewire"  \
		"2" "Pulseaudio"  \
		"3" "Select programs manually"  3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
			programs+=( "pipewire" "pipewire-audio" "pipewire-alsa" "pipewire-jack" "pipewire-pulse" )
			;;
		"2")   
			programs+=( "pulseaudio" "pavucontrol" "alsa-utils" )
			;;
		"3")   
			CHOICES=$(
				whiptail --title "Sound" --separate-output --checklist --notags \
				"\nMusic makes sense when everything else is crazy." 17 60 9 \
				"pulseaudio"      	"pulseaudio" OFF \
				"pavucontrol" 		"pavucontrol" OFF \
				"alsa-utils" 		"alsa-utils" OFF \
				"pipewire" 		"pipewire" OFF \
				"pipewire-audio" 	"pipewire-audio" OFF \
				"pipewire-alsa" 	"pipewire-alsa" OFF \
				"pipewire-pulse" 	"pipewire-pulse" OFF \
				"pipewire-jack" 	"pipewire-jack" OFF \
				"wireplumber" 		"wireplumber" OFF 3>&1 1>&2 2>&3
			)

			# add selected programs to the array
			for CHOICE in $CHOICES; do
				programs+=($CHOICE)
			done

			# print if nothing was selected
			if [ -z $CHOICE ]; then
				echo "No option was selected (user hit Cancel or unselected all options)"
			fi
			;;
	esac

	echo "${programs[@]}"
}

gui() {
 	CHOICES=$(
		whiptail --title "GUI" --separate-output --checklist --notags \
		$'\nThe best GUI is the one you don\'t notice.' 17 60 9 \
		"xorg"      		"xorg" OFF \
		"xorg-xinit" 		"xorg-xinit" OFF \
		"playerctl" 		"playerctl" OFF \
		"qtile-git" 		"qtile-git" OFF \
		"qtile-extras-git" 	"qtile-extras-git" OFF \
		"sddm" 				"sddm" OFF \
		"ly" 				"ly" OFF \
		"qt" 				"qt (group)" OFF \
		"gsimplecal" 		"gsimplecal" OFF 3>&1 1>&2 2>&3
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
		'\n"Life is too short for ugly design." - Stefan Sagmeister' 13 60 5 \
		"lxappearance"     		"lxappearance" OFF \
		"nitrogen"     			"nitrogen" OFF \
		"nerd-fonts-meta"     	"nerd-fonts-meta" OFF \
		"papirus-icon-theme"	"papirus-icon-theme" OFF \
		"picom-jonaburg-git" 	"picom-jonaburg-git" OFF 3>&1 1>&2 2>&3
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
		"steam"      				"steam" OFF \
		"lutris"      				"lutris" OFF \
		"wine-staging"      		"wine-staging" OFF \
		"nvidia"      				"nvidia" OFF \
		"nvidia-dkms" 				"nvidia-dmks" OFF \
		"nvidia-utils" 				"nvidia-utils" OFF \
		"lib32-nvidia-utils" 		"lib32-nvidia-utils" OFF \
		"nvidia-settings" 			"nvidia-settings" OFF \
		"vulkan-icd-loader" 		"vulkan-icd-loader" OFF \
		"lib32-vulkan-icd-loader" 	"lib32-vulkan-icd-loader" OFF \
		"proton-ge-custom" 			"proton-ge-custom" OFF \
		"mangohud-git" 				"mangohud-git" OFF \
		"goverlay-bin" 				"goverlay-bin" OFF \
		"gwe" 						"GreenWithEnvy" OFF 3>&1 1>&2 2>&3
	)

	# add selected programs to the array
	for CHOICE in $CHOICES; do
		programs+=($CHOICE)
		if [ "$CHOICE" == "gwe" ] ; then
			echo "Installing GreenWithEnvy"
			cd ~/Downloads
			git clone --recurse-submodules -j4 https://gitlab.com/leinardi/gwe.git
			cd gwe
			git checkout release
			sudo -H pip3 install -r requirements.txt
			meson . build --prefix /usr
			ninja -v -C build
			sudo ninja -v -C build install
			echo "done"
    	fi
	done

	# print if nothing was selected
	if [ -z $CHOICE ]; then
	  	echo "No option was selected (user hit Cancel or unselected all options)"
	fi

	echo "${programs[@]}"
}

virtualization() {

	CHOICES=$(
		whiptail --title "Virtualization" --separate-output --checklist --notags  \
		'\nVirtualization allows you to do more with less.' 17 60 9  \
		"qemu"      		"qemu" OFF  \
		"libvirt"      		"libvirt" OFF  \
		"virt-manager" 		"virt-manager" OFF  \
		"virt-viewer" 		"virt-viewer" OFF  \
		"dnsmasq" 			"dnsmasq" OFF  \
		"vde2" 				"vde2" OFF  \
		"bridge-utils" 		"bridge-utils" OFF  \
		"openbsd-netcat" 	"openbsd-netcat" OFF  \
		"libguestfs" 		"libguestfs" OFF 3>&1 1>&2 2>&3
	)

	for CHOICE in $CHOICES; do
		programs+=($CHOICE)
	done

	if [ -z $CHOICE ]; then
	  	echo "No option was selected (user hit Cancel or unselected all options)"
	fi
	
	echo "${programs[@]}"
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

reboot() {
	whiptail --title "Warming" --yesno "It is recommended to reboot system after configuring it for \
everything to work. Do you want to do it now?" 8 80
	
	if [ $? -eq 0 ]; then
		reboot
	fi
}

# Menu window
menu() {
	# newline character (\n) for better placement
	# we don't need to "set" shadow for every object as in radiolist
	CHOICE=$(
		whiptail --title "Menu" --cancel-button "Exit" --notags --menu \
		"\nIn order to install selected programs choose the Install option after selecting them \
(the Full Installation option does this automatically at the end of the process)." 21 60 9 \
		"1" "Full Installation (recommended)"  \
		"2" "System Programs"  \
		"3" "GUI"  \
		"4" "Sound"  \
		"5" "Look and Feel"  \
		"6" "Gaming"  \
		"7" "Virtualization"  \
		"8" "Configure Dotfiles"  \
		"9" "Install Selected Programs" 3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
			dependencies
			necessary
			gui
			look_and_feel
			sound
			gaming
			virtualization
			install "${programs[@]}"
			configure_installed
			reboot
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
			virtualization
			menu
			;;
		"8")   
			configure_installed
			menu
			;;
		"9")   
			install "${programs[@]}"
			menu
			;;
	esac
}

### PROGRAM EXECUTION

mkdir -p ~/.config
sudo pacman -Syu

# Description
whiptail --title "Information" --msgbox "This install script requires an Arch-based machine with SystemD. \
Better know what you are doing, because some options NOT selected will conclude in not fully working system!" 9 80

# Navigation
whiptail --title "Navigation" --msgbox "Navigate in lists by using arrow keys. \
Select options with space. Use Tab key to navigate between the <Ok> and <Cancel> buttons." 8 80

menu

exit
