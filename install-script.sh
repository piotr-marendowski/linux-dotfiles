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
exclude_files=(assets script.sh whiptail-script.sh README.md LICENSE .git)

# is virtualization installed? 
is_virtualization=false
# is full installation?
is_full_installation=false

# Array of programs to install
programs=()

## Configure installed packages
configure_installed() {
  # IF USER SELECTS NO THEN GO TO MENU (ELSE IS AT THE BOTTOM OF THE FUNCTIO )
	if whiptail --title "Warming" --yesno "Configuring programs can be really dangerous on \
configured machines, it is advised to run this ONLY on newly set up machines. Do you want to proceed?" 8 80; then
    mkdir -p ~/.config
	mkdir -p ~/Documents
	mkdir -p ~/Games

    # Xorg
    if command -v X -version &> /dev/null
    then
        echo "Configuring Xorg server and adding DWM as default window manager..."
        cp /etc/X11/xinit/xinitrc ~/.xinitrc && echo "(1/4)"
        head -n -5 .xinitrc > .xinitrc-temp && mv .xinitrc-temp .xinitrc && echo "(2/4)"
        echo exec dwm >> ~/.xinitrc && echo "(3/4)"
        rm ~/.xinitrc-new && echo "(4/4)"
        echo "done"
    fi
    
    # theme
    sudo cp $dir/assets/TokyoNight /usr/share/themes/

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

    # login managers - check if pacman -Q name begins with name of the login manager
    # and enable its service if it is
    echo "Proceeding to check if login manager is installed..."
    # if ly is installed
    pacman -Q ly | grep -q "^ly" && sudo systemctl enable ly && echo "Ly installed."

    # start gamemode
    systemctl --user enable gamemoded && systemctl --user start gamemoded

    # virtualization
    if [ "$is_virtualization" = true ]; then

        whiptail --title "VIRTUALIZATION: Warming" --yesno "You need to ensure that these are set to: \
unix_sock_group = \"libvirt\", unix_sock_ro_perms = \"0777\", and unix_sock_rw_perms = \"0770\". \
Do you want to do it now?" 10 80
        if [ $? -eq 0 ]; then
            sudo nvim /etc/libvirt/libvirtd.conf
        fi

        if systemctl status libvirtd; then
            sudo groupadd libvirt
            local user_name=$(whoami)
            sudo usermod -aG libvirt $user_name
            sudo systemctl enable libvirtd
            sudo systemctl restart libvirtd
        else
            echo "libvirt is not installed"
        fi
        else
            echo "Virtualization is not configured right now."
        fi
    
    else
        menu
    fi
}

add_programs() {
    # core
	programs+=( "vieb" "sioyek" "flameshot" "gimp" "htop" "discord-screenaudio" "mellowplayer" "polkit" "gnome-polkit" "zip" "unzip" "tar" "ncdu" "mtpfs" "jmtpfs" "gvfs-mtp" "gvfs-gphoto2" "libreoffice-fresh" "ttf-ms-fonts" "wget" "curl" "ripgrep" "python-pip" "meson" "ninja" "neovim" "lazygit" )

    # sound - pipewire
    programs+=( "pipewire" "pipewire-audio" "pipewire-alsa" "pipewire-jack" "pipewire-pulse" )

    # gui
    programs+=( "xorg" "xorg-xinit" "dwm" "ly" "qt" "redshift" "picom-jonaburg-git" "ttf-jetbrains-mono-nerd" "lxappearance" )

    # gaming
	whiptail --title "Warming" --yesno "Before installing and configuring system for \
gaming, first you need to enable multilib in pacman.conf in order to install 32 bit drivers. \
	Do you want to do it now?" 9 80
	
	if [ $? -eq 0 ]; then
		sudo nvim /etc/pacman.conf
	fi

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

	# programs+=( "steam" "lutris" "wine-staging" "nvidia-utils" "nvidia-settings" "nvidia-settings" "vulkan-icd-loader" "dxvk-bin" "opencl-nvidia" "libvdpau" "libxnvctrl" "lib32-nvidia-utils" "lib32-opencl-nvidia" "lib32-vulkan-icd-loader" "proton-ge-custom-bin" "mangohud-git" "goverlay-bin" "gwe" "protonup-qt-bin" "gamemode" )

    # virtualization
    # programs+=( "qemu" "libvirt" "virt-manager" "virt-viewer" "dnsmasq" "vde2" "bridge-utils" "openbsd-netcat" "libguestfs" )
    # is_virtualization=true
}

install() {
    mkdir -p ~/Downloads

	whiptail --title "Warming" --yesno "Do you want to install selected programs?" 7 45
	
	if [ $? -eq 0 ]; then
		echo "Installing selected programs..."
		# Check if paru is installed
		if ! command -v paru &> /dev/null; then
            echo "Paru could not be found"
            whiptail --title "Information" --msgbox "This will take a few minutes. If it'll be stuck for about 10 minutes then \
restart install script in .dotfiles folder." 9 60
            echo "Proceeding to install Paru AUR helper..."
            sudo pacman -S --noconfirm --needed base-devel
            sudo pacman -Syy
            cd ~/Downloads
            git clone https://aur.archlinux.org/paru.git
            cd paru
            makepkg -si --noconfirm

            cd ..
            rm -r paru
            echo "done"
		fi

		# Loop through the program names array and install each program using paru
		# --noconfirm to automatically say yes to every installation
        whiptail --title "Progress" --gauge "\nDon't panic if its stuck!" 7 50 0 < <(
            for ((i=0; i<${#programs[@]}; i++)); do
                # Install packages and don't print output
                paru -S --noconfirm --quiet "${programs[$i]}" &> /dev/null
                # Update the gauge
                gauge=$((100 * (i + 1) / ${#programs[@]}))
                echo "$gauge"
            done
        )
	fi

	menu
}

reboot() {
	whiptail --title "Warming" --yesno "It is recommended to reboot system after configuration.\
Do you want to do it now?" 8 80

	if [ $? -eq 0 ]; then
		sudo reboot
	fi
}

print_programs() {
    whiptail --title "Programs" --msgbox --scrolltext "$(printf '%s\n' "${programs[@]}")" 20 30
}

unselect_programs() {
    options=()
    for program in "${programs[@]}"; do
        options+=("$program" "")
    done

    # Display the whiptail menu and let the user choose elements to delete
    whiptail --title "Delete Programs" --checklist "Select programs to delete" 20 60 5 "$(printf '%s\n' "${programs[@]}")" 3>&1 1>&2 2>&3

    # Loop through the selected programs and remove them from the array
    for program in ${selected[@]}; do
        programs=("${programs[@]/$program}")
    done

    # Print the updated programs array
    echo "Updated programs array:"
    for program in "${programs[@]}"; do
        echo "$program"
    done
}

# Menu window
menu() {
	CHOICE=$(
		whiptail --title "Menu" --cancel-button "Exit" --notags --menu "" 11 50 4 \
		"1" "Full installation"  \
		"2" "Configure dotfiles and programs"  \
        "3" "Unselect program(s)" \
		"4" "Install selected programs" 3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
            is_full_installation=true
            add_programs
            # choose to unselect programs
            whiptail --title "Warming" --yesno "Do you want to unselect programs?" 8 60
            if [ $? -eq 0 ]; then
                unselect_programs
            fi
			install "${programs[@]}"
			configure_installed
			reboot
			;;
		"2")   
			configure_installed
			menu
			;;
		"3")   
            unselect_programs
		 	menu
		 	;;
		"4")   
			dependencies
			install "${programs[@]}"
            if [ "$is_full_installation" = false ]; then
                menu
            fi
			reboot
			;;
	esac
}

### PROGRAM EXECUTION
sudo pacman --noconfirm -Syu

# Description
whiptail --title "Information" --msgbox "This install script requires an Arch-based machine with SystemD. \
Better know what you are doing, because some options NOT selected will conclude in not fully working system!" 9 80

# Navigation
whiptail --title "Navigation" --msgbox "Navigate lists using arrow keys. Select options with space. \
Use Tab key to navigate between the <Ok> and <Cancel> buttons." 8 80

menu

exit
