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
listbox=white,black
compactbutton=white,black
button=black,white
actbutton=white,black
entry=black,white
actlistbox=black,white
textbox=white,black 
roottext=white,black
emptyscale=white,black
fullscale=white,white
disentry=white,white
actsellistbox=black,white
sellistbox=white,black"

# is virtualization installed? 
is_virtualization=false
# is full installation?
is_full_installation=false

# Array of programs to install
programs=()

## Configure installed packages
configure_installed() {
    # dotfolders directory
    dir=~/.dotfiles
    # create arrays for: folders/normal files, hidden files, and excluded characters/files
    files=(.*)
    exclude=(. ..)
    exclude_files=(assets install-script.sh README.md LICENSE .git)

    # IF USER SELECTS NO THEN GO TO MENU (ELSE IS AT THE BOTTOM OF THE FUNCTIO )
	if whiptail --title "Warming" --yesno "Do you want to configure dotfiles?" 7 50; then
        # theme
        sudo cp -r $dir/assets/TokyoNight /usr/share/themes/

        # make dotfiles
        echo "Searching $dir directory..."
        cd $dir
        # seach for all files in dir
        files+=($(find . -maxdepth 1 -type d -name '.*'))
        files+=($(find . -maxdepth 1 -type d \! -name '.*'))
        files+=($(find . -maxdepth 1 -type f -name '.*'))
        files+=($(find . -maxdepth 1 -type f \! -name '.*'))

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
            files=("${files[@]/$del}")
        done

        echo "Hidden files in $dir: ${files[@]}"

        mkdir -p ~/.config
        mkdir -p ~/Documents
        mkdir -p ~/Games

        # Move any dotfile "listed" (present) in dir to olddir and move a file from this
        # repo to program's directory e.g. ~/.config
        echo "Moving dotfiles from $dir to homedir..."
        echo "DON'T PANIC IF THERE ARE ERRORS!"
        # hidden files/folders
        for file in ${files[@]}; do
            echo "Moving $file to homedir..."
            cp -Rf $dir/$file ~/$file
        done
        echo "done"

        # Configure Suckless' software
        cd ~/.config/st/
        sudo make install

        cd ~/.config/dmenu/
        sudo make install

        # check if pacman -Q name begins with name of ly
        # and enable its service if it is
        echo "Proceeding to check if login manager is installed..."
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
gaming, first you need to enable multilib in pacman.conf in order to install 32-bit drivers. \
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

	whiptail --title "Warming" --yesno "Do you want to begin installation?" 7 45
	
	if [ $? -eq 0 ]; then
		echo "Installing selected programs..."
		# Check if paru is installed
		if ! command -v paru &> /dev/null; then
            echo "Paru could not be found"
            whiptail --title "Information" --msgbox "This will take a few minutes. If it'll be stuck on Arming ConditionNeedsUpdate \
then reboot and restart install script in .dotfiles folder." 9 60
            echo "Proceeding to install Paru AUR helper..."
            clear
            sudo pacman -S --noconfirm --needed base-devel
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
        whiptail --title "Program Installation" --gauge "\nDon't panic if its stuck!" 7 50 0 < <(
            for ((i=0; i<${#programs[@]}; i++)); do
                # Install packages and don't print output
                paru -S --noconfirm --quiet "${programs[$i]}" &> /dev/null
                # Update the gauge
                gauge=$((100 * (i + 1) / ${#programs[@]}))
                echo "$gauge"
            done
        )
	fi
}

reboot_now() {
	whiptail --title "Warming" --yesno "Do you want to reboot now?" 7 50

	if [ $? -eq 0 ]; then
		sudo reboot
	fi
}

print_programs() {
    whiptail --title "Programs" --msgbox --scrolltext "$(printf '%s\n' "${programs[@]}")" 20 30
}

add_manually() {
	while true; do
	    program=$(whiptail --ok-button "Add" --inputbox "Enter one program at the time:" 8 60 --title "Add Program" 3>&1 1>&2 2>&3)
	    if [ $? = 0 ]; then
            # Add the program name to the programs array
            programs+=("$program")
            else
            # Exit the loop if the user cancels the input
            break
	    fi
	done

	echo "${programs[@]}"
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
		whiptail --title "Menu" --ok-button "Select" --cancel-button "Exit" --notags --menu "" 12 50 5 \
		"1" "Full installation"  \
		"2" "Configure dotfiles"  \
        "3" "Unselect program(s)" \
        "4" "Add program(s) manually" \
		"5" "Install selected programs" 3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
            add_programs
            # choose to unselect programs
            whiptail --title "Warming" --yesno "Do you want to unselect programs?" 8 40
            if [ $? -eq 0 ]; then
                unselect_programs
            fi
			install "${programs[@]}"
			configure_installed
            sudo rm /etc/profile.d/firstboot.sh
			reboot_now
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
            add_manually
		 	menu
		 	;;
		"5")   
			install "${programs[@]}"
            menu
			;;
	esac
}

### PROGRAM EXECUTION
sudo pacman --noconfirm -Syu

# Navigation
whiptail --title "Navigation" --msgbox "Navigate lists using arrow keys. Select options with space. \
Use Tab key to navigate between the <Ok> and <Cancel> buttons." 8 80

menu

exit
