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

# Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
# Clear the color after that
clear='\033[0m'

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
# gtk-engine-murrine and gnome-themes-extra for GTK theme
paru_packages=(alsa-utils discord-canary spotify gtk-engine-murrine gnome-themes-extra)
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
# alsa - audio, playerctl - keyboard volume, ripgrep - lvim dependency, qt5ct - qt theme changer
# noto-fonts - for unicode and other characters, lxappearance - GTK theme changer
install_necessary() {
	echo "Updating machine..."
	mkdir -p ~/.config
	sudo pacman -Syu
	echo "done"

	echo "Proceeding to download necessary programs..."
	sudo pacman -S nvidia alacritty rofi dunst htop flameshot alsa wget curl ripgrep python-pip pulseaudio pavucontrol gimp firefox neovim tree
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
	sudo pacman -S xorg-xinit playerctl qtile
	paru -S qtile-extras
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

# configure firefox - copy prefs.js to .mozilla
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
	sudo pacman -S papirus-icon-theme lxappearance qt5ct gtk4 gtk3 gtk2 feh redshift
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
	        2) mkdir -p ~/.local/share/fonts/JetBrainsMono
			   cp $dir/assets/JetBrainsMono ~/.local/share/fonts/JetBrainsMono ; menu ;;
			*) echo "Wrong option" ;;
        esac
	echo "done"

	echo "Customizing theme..."
	sudo cp $dir/assets/TokyoNight /usr/share/themes/
	echo "done"

	clear
	echo "Look configured."
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
	echo "Remember that this script requires Arch-based machine with SystemD!"
	printf "Requirements: git and this repo as .dotfiles
	$(ColorGreen '1)') Full installation - all at once
	$(ColorGreen '2)') Install necessary packages and programs
	$(ColorGreen '3)') Install GUI - xorg, qtile, ly
	$(ColorGreen '4)') Make dotfiles
	$(ColorGreen '5)') Set up Git
	$(ColorGreen '6)') Customize look and feel
	$(ColorGreen '7)') GUI ONLY! Configure Firefox
	$(ColorGreen 'q)') Quit
	$(ColorBlue 'Choose an option:') "
		read -r option
        case $option in
			1) install_necessary
			   install_gui
			   make_dotfiles
			   set_git
			   look_and_feel ; menu ;;
	        2) install_necessary ; menu ;;
	        3) install_gui ; menu ;;
			4) make_dotfiles ; menu ;;
			5) set_git ; menu ;;
			6) look_and_feel ; menu ;;
			7) firefox_profile ; menu ;;
			q) exit 0 ;;
			*) echo -e $red"Wrong option"$clear; exit 0;;
        esac
}

# initialize menu
menu
