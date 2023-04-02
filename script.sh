#!/bin/bash
# This script creates symlinks from the home directory to any desired dotfolders in ~/.dotfiles
# ONLY FOR ARCH-BASED MACHINES!

# Color  Variables
green='\e[32m'
blue='\e[34m'
clear='\e[0m'

# Color Functions
ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}

### VARIABLES
# dotfolders directory
dir=~/.dotfiles
# old dotfolders backup directory
olddir=~/.dotfiles_old 
# create arrays for: folders/normal files, hidden files, and excluded characters/files
folders=(*)
files=(.*)
exclude=(. ..)
exclude_files=(firefox script.sh README.md LICENSE .git)
# alsa - volume, qtile-extras - for more customization in qtile, gsimplecal - calendar
# tbsm - login/session manager
paru_packages=(alsa-utils discord-canary spotify)
# for Mpris widgets in qtile
pip_packages=(dbus-next pyxdg)


# virtualization:
# sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs dmidecode
# sudo systemctl start libvirtd
# /etc/libvirt/libvirtd.conf
# sudo usermod -aG libvirt $username
# sudo systemctl restart libvirtd

### INSTALLING PROGRAMS
# basic programs
# alsa - audio, playerctl - keyboard volume, ripgrep - lvim dependency,
# noto-fonts - for unicode and other characters
install_necessary() {
	echo "Updating machine..."
	mkdir -p ~/.config
	sudo pacman -Syu
	echo "done"

	echo "Proceeding to download necessary programs..."
	sudo pacman -S nvidia alacritty rofi dunst nitrogen redshift htop flameshot alsa wget curl ripgrep noto-fonts noto-fonts-cjk python-pip pulseaudio pavucontrol gimp papirus-icon-theme
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

	echo "Proceeding to download programs by Paru..."
	for package_name in ${paru_packages[@]}; do
		paru -S $package_name
	done
	echo "done"

	## specific programs
	echo "Downloading Lunarvim..."
	bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh)
	echo "done"

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

	clear
}
install_gui() {
	echo "Proceeding to download necessary programs..."
	sudo pacman -S xorg-xinit playerctl qtile
	paru -S qtile-extras
	paru -S gsimplecal
	paru -S ly
	echo "done"

	# set up xorg and qtile for GUI in homedir
	echo "Configuring Xorg server and adding Qtile as default window manager..."
	cp /etc/X11/xinit/xinitrc ~/.xinitrc
	head -n -5 > .xinitrc-new && mv .xinitrc-new ~/.xinitrc
	echo exec qtile start >> ~/.xinitrc
	echo "done"

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
}

# configure firefox - copy prefs.js to .mozilla
firefox_profile() {
	profile_name=profile1
	echo "Configuring Firefox..."
	firefox -CreateProfile "$profile_name" && firefox -P "$profile_name" -no-remote
	cd ~/.mozilla/firefox/*$profile_name*/
	cp $dir/firefox/prefs.js /prefs.js
	echo "done"
	clear
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
	echo "exiting..."
	clear
}

# check if filget is install if not install it (to display ascii art)
check_figlet() {
	if ! command -v figlet -h &> /dev/null
	then
		echo "To see an ASCII art you need to have figlet installed"
		echo "Proceeding to install figlet..."
		sudo pacman -S figlet
		echo "done"
	fi
}

### MENU
menu() {
	check_figlet
	clear
	figlet Dotfiles script
	printf "Remember that this script requires Arch-based machine with SystemD!
	$(ColorGreen '1)') Install necessary packages and programs
	$(ColorGreen '2)') Install GUI - xorg, qtile, ly
	$(ColorGreen '3)') Make dotfiles
	$(ColorGreen '4)') Configure Firefox
	$(ColorGreen '5)') Full installation - all at once
	$(ColorGreen 'q)') Quit
	$(ColorBlue 'Choose an option:') "
		read -r option
        case $option in
	        1) install_necessary ; menu ;;
	        2) install_gui ; menu ;;
			3) make_dotfiles ; menu ;;
			4) firefox_profile ; menu ;;
			5) install_necessary
			   install_gui
			   make_dotfiles
			   firefox_profile ; menu ;;
			q) exit 0 ;;
			*) echo -e $"Wrong option"$clear; exit 0;;
        esac
}

# initialize menu
menu
