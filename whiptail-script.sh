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

### CUSTOM FUNCTIONS
## The following functions are not used in every window, thus it makes them user-requested.

# Note window based on chose section
#note() {
#	case $CHOICE
#}

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

## Install necessary
# basic programs
# alsa - audio, playerctl - keyboard volume, ripgrep - lvim dependency, qt5ct - qt theme changer
# noto-fonts - for unicode and other characters, lxappearance - GTK theme changer
install_necessary() {
	echo "Updating machine..."
	mkdir -p ~/.config
	sudo pacman -Syu
	echo "done"

	echo "Proceeding to download necessary programs..."
	sudo pacman -S alacritty rofi dunst htop flameshot wget curl ripgrep python-pip pulseaudio pavucontrol gimp firefox neovim tree
	echo "done"

	# check if there is Paru on machine and install it if not
	echo "Checking if there is Paru installed..."
	if ! command -v paru -h &> /dev/null
	then
		echo "Paru could not be found"
		echo "Proceeding to install Paru AUR helper..."
		sudo pacman -S --needed base-devel
		git clone https://aur.archlinux.org/paru.git
		cd paru
		makepkg -si
		echo "done"
	else
		echo "Paru is already installed"
	fi

	# alsa - volume, qtile-extras - for more customization in qtile, gsimplecal - calendar
	# gtk-engine-murrine and gnome-themes-extra for GTK theme
	paru_packages=(alsa-utils discord-canary spotify gtk-engine-murrine gnome-themes-extra network-manager-applet)

	echo "Proceeding to download programs by Paru..."
	for package_name in ${paru_packages[@]}; do
		paru -S $package_name
	done
	echo "done"

	## specific programs
	# customize dunst
	echo "Configuring Dunst..."
	mkdir -p ~/.config/dunst
	cp /etc/dunst/dunstrc ~/.config/dunst/dunstrc
	echo "done"

	# customize alacritty
	echo "Configuring Alacritty..."
	mkdir -p ~/.config/alacritty
	cp /usr/share/doc/alacritty/example/alacritty.yml ~/.config/alacritty/alacritty.yml
	echo "done"

	# customize rofi
	echo "Configuring Rofi..."
	mkdir -p ~/.config/rofi
	rofi -dump-config > ~/.config/rofi/config.rasi
	cp $dir/rofi/simple-tokyonight.rasi ~/.config/rofi/simple-tokyonight.rasi
	echo "done"

	# install LunarVim
	echo "Downloading Lunarvim..."
	#bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh)
	# LunarVim seems to give some errors
	echo "done"

	clear
	echo "Packages installed."
}
install_gui() {
	echo "Proceeding to download necessary programs..."
	sudo pacman -S xorg-xinit playerctl
	paru -s qtile-git
	paru -s qtile-extras-git
	paru -S gsimplecal
	paru -S ly
	echo "done"

	# set up xorg and qtile for GUI in homedir
	echo "Configuring Xorg server and adding Qtile as default window manager..."
	cp /etc/X11/xinit/xinitrc ~/.xinitrc && echo "(1/4)"
	head -n -5 .xinitrc > .xinitrc-temp && mv .xinitrc-temp .xinitrc && echo "(2/4)"
	echo exec qtile start >> ~/.xinitrc && echo "(3/4)"
	rm ~/.xinitrc-new && echo "(4/4)"
	echo "done"

	# for Mpris widgets in qtile
	pip_packages=(dbus-next pyxdg)

	echo "Proceeding to download programs by pip..."
	for package_name in ${pip_packages[@]}; do
		pip install $package_name
	done
	echo "done"

	# set up session manager
	echo "Proceeding to set up Ly..."
	sudo systemctl enable ly.service
	echo "done"

	clear
	echo "Packages installed."
}

# GUI ONLY! configure firefox - copy prefs.js to .mozilla
firefox_profile() {
	profile_name=profile1
	echo "Configuring Firefox..."
	firefox -CreateProfile "$profile_name" && firefox -P "$profile_name" -no-remote
	cd ~/.mozilla/firefox/*$profile_name*/
	cp $dir/firefox/prefs.js /prefs.js
	echo "done"

	clear
	echo "Remember to change default profile to $profile_name in Firefox."
}

### DOTFILES
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

# Set git user
set_git() {
	echo "Setting up Git..."
	[ -z `git config --global user.name` ] && git config --global user.name "name"
	[ -z `git config --global user.email` ] && git config --global user.email "mail@mail.com"
	echo "done"
	clear
	echo "Git configured."
}

# customize GTK and QT themes
look_and_feel() {
	echo "Installing necessary packages..."
	sudo pacman -S papirus-icon-theme lxappearance nitrogen qt5ct gtk4 gtk3 gtk2 redshift
	# noto-fonts noto-fonts-cjk 
	echo "done"

	# configure fonts
	echo "Configuring fonts..."
	printf "Do you want to install:
	$(ColorGreen '1)') All of Nerd Fonts (about 3.5 GB)
	$(ColorGreen '2)') Only JetBrains Mono (about 30 MB)
	$(ColorBlue 'Choose an option:') "
		read -r option
        case $option in
			1) paru -S nerd-fonts-meta ; menu ;;
	        2) mkdir -p ~/.local/share/fonts
			   cp -r $dir/assets/JetBrainsMono ~/.local/share/fonts ;;
			*) echo "Wrong option" ;;
        esac
	echo "done"

	echo "Customizing theme..."
	sudo cp $dir/assets/TokyoNight /usr/share/themes/
	echo "done"

	echo "Installing custom Picom compositor..."
	paru -S picom-jonaburg-git
	echo "done"

	echo "Setting wallpaper..."
	nitrogen --set-zoom-fill $dir/assets/wallpaper.jpg
	echo "done"

	clear
	echo "Look configured."
}

# optimize system for gaming, install needed software for it
gaming() {
	echo "Optimizing system for gaming..."

	echo "ENABLE MULTILIB IN ORDER TO INSTALL DRIVERS!"
	printf "Ok?: "
	read -r input

	sudo nvim /etc/pacman.conf
	echo "done"

	echo "Installing drivers..."
	sudo pacman -S --needed nvidia nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
	echo "done"

	echo "Installing necessary software..."
	sudo pacman -S steam lutris wine-staging
	paru -S proton-ge-custom
	paru -S mangohud
	paru -S goverlay	# gui to edit mangohud
	#paru -S gwe			# greenwithenvy for fans and temp control
	echo "Installing GreenWithEnvy"
	sudo pacman -S meson ninja

	cd ~/Downloads
	git clone --recurse-submodules -j4 https://gitlab.com/leinardi/gwe.git
	cd gwe
	git checkout release
	sudo -H pip3 install -r requirements.txt
	meson . build --prefix /usr
	ninja -v -C build
	sudo ninja -v -C build install
	echo "done"

	clear
	echo "System optimized for gaming, good luck on the battlefield!"
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

	result=$(whoami)
	case $CHOICE in
		"1)")   
			result="I am $result, the name of the script is start"
			break
		;;
		"2)")   
				OP=$(uptime | awk '{print $3;}')
			result="This system has been up $OP minutes"
		;;
		"9)") exit
			;;
	esac
	whiptail --msgbox "$result" 10 90
	done
}

### CORE funtions
## The following functions are defined here for convenience.
## All these functions are used in each of the five window functions.
max() {
	echo -e "$1\n$2" | sort -n | tail -1
}

getbiggestword() {
	echo "$@" | sed "s/ /\n/g" | wc -L
}

replicate() {
	local n="$1"
	local x="$2"
	local str

	for _ in $(seq 1 "$n"); do
		str="$str$x"
	done
	echo "$str"
}

programchoices() {
	choices=()
	local maxlen
	maxlen="$(getbiggestword "${!checkboxes[@]}")"
	linesize="$(max "$maxlen" 50)"
	local spacer
	spacer="$(replicate "$((linesize - maxlen))" " ")"

	for key in "${!checkboxes[@]}"; do
		# A portable way to check if a command exists in $PATH and is executable.
		# If it doesn't exist, we set the tick box to OFF.
		# If it exists, then we set the tick box to ON.
		if ! command -v "${checkboxes[$key]}" >/dev/null; then
			# $spacer length is defined in the individual window functions based
			# on the needed length to make the checkbox wide enough to fit window.
			choices+=("${key}" "${spacer}" "OFF")
		else
			choices+=("${key}" "${spacer}" "ON")
		fi
	done
}

selectedprograms() {
	result=$(
		# Creates the whiptail checklist. Also, we use a nifty
		# trick to swap stdout and stderr.
		whiptail --title "$title" \
			--checklist "$text" 22 "$((linesize + 12))" 12 \
			"${choices[@]}" \
			3>&2 2>&1 1>&3
	)
}

exitorinstall() {
	local exitstatus="$?"
	# Check the exit status, if 0 we will install the selected
	# packages. A command which exits with zero (0) has succeeded.
	# A non-zero (1-255) exit status indicates failure.
	if [ "$exitstatus" = 0 ]; then
		# Take the results and remove the "'s and add new lines.
		# Otherwise, pacman is not going to like how we feed it.
		programs=$(echo "$result" | sed 's/" /\n/g' | sed 's/"//g')
		echo "$programs"
		paru --needed --ask 4 -Syu "$programs" ||
			echo "Failed to install required packages."
	else
		echo "User selected Cancel."
	fi
}

install() {
	local title="${1}"
	local text="${2}"
	declare -A checkboxes

	# Loop through all the remaining arguments passed to the install function
	for ((i = 3; i <= $#; i += 2)); do
		key="${!i}"
		value=""
		eval "value=\${$((i + 1))}"
		if [ -z "$value" ]; then
			value="$key"
		fi
		checkboxes["$key"]="$value"
	done

	programchoices && selectedprograms && exitorinstall
}


### PROGRAM EXECUTION
# Call the function with any number of applications as arguments. example:
# install "Title" "Description" "Program-1-KEY" "Program-1-VALUE" "Program-2-KEY" "Program-2-VALUE" ...
# Note an empty string "" means that the KEY and the VALUE are the same like "firefox" "firefox" instead you can write "firefox" ""

# Hello window
whiptail --title "Install script" --msgbox "This install script requires an Arch-based machine. For your own good configure sudo (with visudo) before. \
Use TAB for navigation in <Ok> and <Cancel> options. After this window will you will be prompted to install Paru - AUR helper which is used to \
download every program." 10 90

# Menu
menu

# Sound

# 

# Necessary
install "Web Browsers" "Select one or more web browsers to install.\n" \
"brave" "chromium" "firefox" "librewolf" "qutebrowser" ""

# GUI
#
# Look and feel

# Optional 
install "Optional downloads" "Other programs available for installation.\n" "discord-canary" \
"" ""

# Games
install "Gaming" "steam" "lutris" "" ""

exit
