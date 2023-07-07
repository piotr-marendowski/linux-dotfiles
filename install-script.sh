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
        mkdir ~/.local/share/themes
        cp -r ~/tokyo-night-sddm ~/.local/share/themes/

        # edit /etc/sddm.conf
        # read the contents of line 31 into a variable
        line31=$(sed -n '31p' /etc/sddm.conf)
        # check if the contents of line 31 match
        if [[ "$line31" == *"[Theme]"* ]]; then
            # if the pattern is matched, replace the line 33 with a theme name
            sed -i '33s/.*/Current=tokyo-night-sddm/' /etc/sddm.conf
        fi
    fi

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

## Function with dependencies to all of the programs
dependencies() {
	dependencies_list=(wget curl ripgrep python-pip meson ninja neovim lazygit)

	mkdir -p ~/Downloads
	
	# check if there is Paru on machine and install it if not
	echo "Checking if there is Paru installed..."
	if ! command -v paru -h &> /dev/null
	then
		echo "Paru could not be found"
		echo "Proceeding to install Paru AUR helper..."
		sudo pacman -S --noconfirm --needed base-devel
		cd ~/Downloads
		git clone https://aur.archlinux.org/paru.git
		cd paru
		makepkg -si
		echo "done"
	fi

	# add them to the programs array
	programs+=( "${dependencies_list[@]}" )

    # check if machine has an nvidia card
    # Check if lspci is installed
    if ! command -v lspci &> /dev/null; then
        paru -S --noconfirm lspci
    fi

      # Use lspci to check for NVIDIA graphics card
    if lspci | grep -i NVIDIA &> /dev/null; then
        programs+=( nvidia-dkms nvidia-utils )
    else
        echo "NVIDIA graphics card not found."
    fi

	echo "${programs[@]}"
}

## FOR EVERY FUNCTION BELOW:
# tag and descriptions --notags is used to only show descriptions
# newline character (\n) is for better placement
# don't know if it will be different on other monitors, but in mine it displays all equally
# third argument in dimensions = number of options
utilities() {
	CHOICE=$(
		whiptail --title "Programs" --cancel-button "Exit" --notags --menu \
		"\nCore and optional programs." 12 60 3 \
        "1" "Minimal" \
        "2" "Everything" \
		"3" "Select programs manually" 3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
			programs+=( "alacritty" "rofi" "firefox" "htop" "nemo" "polkit" "gnome-polkit" "zip" "unzip" "tar" )
			;;
		"2")   
			programs+=( "alacritty" "rofi" "flameshot" "gimp" "firefox" "htop" "nemo" "discord-canary" "spotify" "polkit" "gnome-polkit" "ark" "zip" "unzip" "tar" "ncdu" "mtpfs" "jmtpfs" "gvfs-mtp" "gvfs-gphoto2" "libreoffice-fresh" "ttf-ms-fonts" )
			;;
		"3")   
            CHOICES=$(
                whiptail --title "Programs" --separate-output --checklist --notags \
                "\nCore and optional programs." 18 60 10 \
                "alacritty"      	        "alacritty" OFF \
                "rofi" 				        "rofi"  OFF \
                "dunst" 			        "dunst" OFF \
                "flameshot" 			    "flameshot" OFF \
                "gimp" 				        "gimp" OFF \
                "firefox" 			        "firefox" OFF \
                "htop" 				        "htop" OFF \
                "discord-canary" 		    "discord-canary" OFF \
                "spotify" 				    "spotify" OFF \
                "nemo" 				        "nemo" OFF \
                "polkit" 				    "polkit" OFF \
                "gnome-polkit" 		        "gnome-polkit" OFF \
                "zip"			            "zip" OFF \
                "unzip"			            "unzip" OFF \
                "tar"			            "tar" OFF \
                "ark" 		                "ark" OFF \
                "vieb-bin" 		            "vieb-bin" OFF \
                "ncdu" 		                "ncdu" OFF \
                "libreoffice-fresh" 		"libreoffice-fresh" OFF \
                "ttf-ms-fonts" 		        "ttf-ms-fonts" OFF \
                "mtpfs (android)" 		    "mtpfs" OFF \
                "jmtpfs (android)" 		    "jmtpfs" OFF \
                "gvfs-mtp (android)" 		"gvfs-mtp" OFF \
                "gvfs-gphoto2 (android)"    "gvfs-gphoto2" OFF 3>&1 1>&2 2>&3
            )

			# add selected programs to the array
			for CHOICE in $CHOICES; do
				programs+=($CHOICE)
			done
			;;
    esac

	echo "${programs[@]}"
}

sound() {
	CHOICE=$(
		whiptail --title "Sound" --cancel-button "Exit" --notags --menu \
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
				"\nMusic makes sense when everything else is crazy." 18 60 10 \
				"pulseaudio"            "pulseaudio" OFF \
				"pavucontrol" 		    "pavucontrol" OFF \
				"alsa-utils" 		    "alsa-utils" OFF \
				"pipewire" 		        "pipewire" OFF \
				"pipewire-audio" 	    "pipewire-audio" OFF \
				"pipewire-alsa" 	    "pipewire-alsa" OFF \
				"pipewire-pulse" 	    "pipewire-pulse" OFF \
				"pipewire-jack" 	    "pipewire-jack" OFF \
				"easyeffects" 	        "easyeffects" OFF \
				"wireplumber" 		    "wireplumber" OFF 3>&1 1>&2 2>&3
			)

			# add selected programs to the array
			for CHOICE in $CHOICES; do
				programs+=($CHOICE)
			done
			;;
	esac

	echo "${programs[@]}"
}

gui() {
	CHOICE=$(
		whiptail --title "GUI" --cancel-button "Exit" --notags --menu \
		"\nThe best GUI is the one you don't notice." 12 60 3 \
        "1" "Qtile (Xorg)"  \
        "2" "Clean Xorg"  \
		"3" "Select programs manually"  3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
			programs+=( "xorg" "xorg-xinit" "playerctl" "qtile-git" "qtile-extras-git" "sddm" "qt" "gsimplecal" )
			;;
		"2")   
			programs+=( "xorg" "xorg-xinit" )
			;;
		"3")   
            CHOICES=$(
                whiptail --title "GUI" --separate-output --checklist --notags \
                $'\nThe best GUI is the one you don\'t notice.' 17 60 9 \
                "xorg"      		    "xorg" OFF \
                "xorg-xinit" 		    "xorg-xinit" OFF \
                "playerctl" 		    "playerctl" OFF \
                "qtile-git" 		    "qtile-git" OFF \
                "qtile-extras-git" 	    "qtile-extras-git" OFF \
                "sddm" 				    "sddm" OFF \
                "ly" 				    "ly" OFF \
                "qt" 				    "qt (group)" OFF \
                "gsimplecal" 		    "gsimplecal" OFF 3>&1 1>&2 2>&3
            )

            # add selected programs to the array
            for CHOICE in $CHOICES; do
                programs+=($CHOICE)
            done
    esac

	echo "${programs[@]}"
}

# customize GTK and QT themes
look_and_feel() {
	CHOICE=$(
		whiptail --title "Look and feel" --cancel-button "Exit" --notags --menu \
		"\nLife is too short for ugly design." 12 60 3 \
        "1" "Everything"  \
		"2" "Select programs manually"  3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
			programs+=( "lxappearance" "nitrogen" "redshift" "nerd-fonts-meta" "papirus-icon-theme" "picom-jonaburg-git" )
			;;
		"2")   
            CHOICES=$(
                whiptail --title "Look and feel" --separate-output --checklist --notags \
                '\nLife is too short for ugly design.' 14 60 6 \
                "lxappearance"     		    "lxappearance" OFF \
                "nitrogen"     			    "nitrogen" OFF \
                "redshift"     			    "redshitf" OFF \
                "nerd-fonts-meta"     	    "nerd-fonts-meta" OFF \
                "papirus-icon-theme"	    "papirus-icon-theme" OFF \
                "picom-jonaburg-git" 	    "picom-jonaburg-git" OFF 3>&1 1>&2 2>&3
            )

            # add selected programs to the array
            for CHOICE in $CHOICES; do
                programs+=($CHOICE)
            done
    esac

	echo "${programs[@]}"
}

gaming() {
	whiptail --title "Warming" --yesno "Before installing and configuring system for \
gaming, first you need to enable multilib in pacman.conf in order to install 32 bit drivers. \
	Do you want to do it now?" 9 80
	
	if [ $? -eq 0 ]; then
		sudo nvim /etc/pacman.conf
	fi

	CHOICE=$(
		whiptail --title "Gaming" --cancel-button "Exit" --notags --menu \
		"\nThe game is never over, unless you stop playing." 11 60 2 \
		"1" "Nvidia" \
		"2" "Select programs manually"  3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
			programs+=( "steam" "lutris" "wine-staging" "nvidia-utils" "nvidia-settings" "nvidia-settings" "vulkan-icd-loader" "dxvk-bin" "opencl-nvidia" "libvdpau" "libxnvctrl" "lib32-nvidia-utils" "lib32-opencl-nvidia" "lib32-vulkan-icd-loader" "proton-ge-custom-bin" "mangohud-git" "goverlay-bin" "gwe" "protonup-qt-bin" "gamemode" )
			;;
		"2")   
            CHOICES=$(
                whiptail --title "Gaming" --separate-output --checklist --notags \
                "\nThe game is never over, unless you stop playing." 18 60 10 \
                "steam"      				    "steam" OFF \
                "lutris"      				    "lutris" OFF \
                "wine-staging"      		    "wine-staging" OFF \
                "nvidia"      				    "nvidia" OFF \
                "nvidia-dkms" 				    "nvidia-dkms" OFF \
                "nvidia-utils" 				    "nvidia-utils" OFF \
                "nvidia-settings" 			    "nvidia-settings" OFF \
                "vulkan-icd-loader" 		    "vulkan-icd-loader" OFF \
                "dxvk-bin" 		                "dxvk-bin" OFF \
                "opencl-nvidia" 		        "opencl-nvidia" OFF \
                "libvdpau" 		                "libvdpau" OFF \
                "libxnvctrl" 		            "libxnvctrl" OFF \
                "lib32-nvidia-utils" 		    "lib32-nvidia-utils" OFF \
                "lib32-opencl-nvidia" 		    "lib32-opencl-nvidia" OFF \
                "lib32-vulkan-icd-loader"       "lib32-vulkan-icd-loader" OFF \
                "proton-ge-custom-bin" 			"proton-ge-custom-bin" OFF \
                "mangohud-git" 				    "mangohud-git" OFF \
                "goverlay-bin" 				    "goverlay-bin" OFF \
                "protonup-qt-bin" 		        "protonup-qt-bin" OFF \
                "gamemode" 		                "gamemode" OFF \
                "gwe" 						    "GreenWithEnvy" OFF 3>&1 1>&2 2>&3
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
            ;;
        esac

        echo "${programs[@]}"
    }

    virtualization() {
        CHOICE=$(
            whiptail --title "Virtualization" --cancel-button "Exit" --notags --menu \
		"\nVirtualization allows you to do more with less." 11 60 2 \
		"1" "Install and configure virtualization" \
		"2" "Select programs manually" 3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
			programs+=( "qemu" "libvirt" "virt-manager" "virt-viewer" "dnsmasq" "vde2" "bridge-utils" "openbsd-netcat" "libguestfs" )
            is_virtualization=true
			;;
		"2")   
            CHOICES=$(
                whiptail --title "Virtualization" --separate-output --checklist --notags  \
                '\nVirtualization allows you to do more with less.' 17 60 9  \
                "qemu"      		    "qemu" OFF  \
                "libvirt"      		    "libvirt" OFF  \
                "virt-manager" 		    "virt-manager" OFF  \
                "virt-viewer" 		    "virt-viewer" OFF  \
                "dnsmasq" 			    "dnsmasq" OFF  \
                "vde2" 				    "vde2" OFF  \
                "bridge-utils" 		    "bridge-utils" OFF  \
                "openbsd-netcat" 	    "openbsd-netcat" OFF  \
                "libguestfs" 		    "libguestfs" OFF 3>&1 1>&2 2>&3
            )
            is_virtualization=true

			# add selected programs to the array
			for CHOICE in $CHOICES; do
				programs+=($CHOICE)
			done

			# print if nothing was selected
			if [ -z $CHOICE ]; then
				echo "No option was selected (user hit Cancel or unselected all options)"
                is_virtualization=false
			fi
			;;
	esac

	echo "${programs[@]}"
    echo $is_virtualization
}

install() {
	whiptail --title "Warming" --yesno "Do you want to install selected programs?" 7 45
	
	if [ $? -eq 0 ]; then
		echo "Installing selected programs..."
		# Check if paru is installed
		if ! command -v paru &> /dev/null; then
			echo "Paru is not installed. Installing it..."
			sudo pacman -S --noconfirm --needed base-devel
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

add_manually() {
	while true; do
	    program=$(whiptail --inputbox "Enter one program at the time:" 8 80 --title "Program Input" 3>&1 1>&2 2>&3)
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
	# newline character (\n) for better placement
	# we don't need to "set" shadow for every object as in radiolist
	CHOICE=$(
		whiptail --title "Menu" --cancel-button "Exit" --notags --menu \
		"\nIn order to install selected programs choose the Install option after selecting them \
(the Full Installation option does this automatically at the end of the process)." 24 60 12 \
		"1" "Full Installation (recommended)"  \
		"2" "System Programs"  \
		"3" "GUI"  \
		"4" "Sound"  \
		"5" "Look and Feel"  \
		"6" "Gaming"  \
		"7" "Virtualization"  \
		"8" "Configure Dotfiles"  \
		"9" "Add Programs That Are Not Listed"  \
		"10" "Print Selected Programs"  \
        "11" "Unselect Program(s)" \
		"12" "Install Selected Programs" 3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
            is_full_installation=true
			dependencies
			utilities
			gui
			look_and_feel
			sound
			gaming
			virtualization
            # choose to unselect programs
            whiptail --title "Warming" --yesno "Do you want to unselect programs?" 8 50
            if [ $? -eq 0 ]; then
                unselect_programs
            fi
			install "${programs[@]}"
			configure_installed
			reboot
			;;
		"2")   
			utilities
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
			add_manually
			menu
			;;
		"10")   
            print_programs
			menu
			;;
		"11")   
            unselect_programs
		 	menu
		 	;;
		"12")   
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
