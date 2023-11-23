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

is_virtualization=false         # is virtualization enabled? 
programs=()                     # array of programs to install
dir=~/Downloads/dotfiles        # dotfiles directory

# check for sudo program
if command -v doas &> /dev/null
then
    sudo_program=doas
else
    sudo_program=sudo
fi

## Configure installed packages in progress bar
# &> /dev/null IS USED TO SEND OUTPUT OF THE COMMANDS INTO THE VOID, SO THEY ARE NOT DISPLAYED ON PROGRESS BAR
configure_installed() {
    # IF USER SELECTS NO THEN GO TO MENU (ELSE IS AT THE BOTTOM OF THE FUNCTION)
	if whiptail --title "Warming" --yesno "Do you want to configure dotfiles?" 7 38; then

        # Make zsh default shell
	    whiptail --title "Shell" --yesno "Do you want to make zsh default shell?" 7 42
        if [ $? -eq 0 ]; then
            $sudo_program chsh -s /usr/bin/zsh &> /dev/null
            $sudo_program chsh -s /bin/zsh &> /dev/null
        fi
        
        whiptail --title "Progress" --gauge "\nConfiguring dotfiles..." 7 50 0 < <(
            # Update the gauge
            gauge=$((100 * 1 / 6)) && echo "$gauge"

            # Move dotfiles to home
            cp -rf $dir/. ~ &> /dev/null

            ####################################################
            gauge=$((100 * 2 / 6)) && echo "$gauge"

            # install fff file manager
            cd ~/Downloads
            git clone https://github.com/piotr-marendowski/fff &> /dev/null
            cd fff
            $sudo_program make install &> /dev/null

            # move wallpaper to ~/.config
            cp $dir/assets/wallpaper.jpg ~/.config/ &> /dev/null

            # delete unnecessary items
            $sudo_program rm -r ~/assets &> /dev/null
            $sudo_program rm -r ~/install.sh &> /dev/null
            $sudo_program rm -r ~/LICENSE &> /dev/null
            $sudo_program rm -r ~/README.md &> /dev/null
            $sudo_program rm -r ~/.config/.config/ &> /dev/null
            $sudo_program rm -r ~/.git/ &> /dev/null

            ####################################################
            gauge=$((100 * 3 / 6)) && echo "$gauge"

            # Dowload Hack Nerd Font and install it
            curl -fLo "Hack Nerd Font Regular.ttf" \
            https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf &> /dev/null

            $sudo_program mkdir -p /usr/share/fonts/TTF/ &> /dev/null
            $sudo_program mv Hack\ Nerd\ Font\ Regular.ttf /usr/share/fonts/TTF/ &> /dev/null

            # Configure Suckless' software
            cd ~/.config/st/ &> /dev/null
            $sudo_program make install &> /dev/null

            cd ~/.config/dmenu/ &> /dev/null
            $sudo_program make install &> /dev/null

            cd ~/.config/dwm/ &> /dev/null
            $sudo_program make install &> /dev/null

            $sudo_program mkdir /usr/share/xsessions/ &> /dev/null
            $sudo_program touch /usr/share/xsessions/dwm.desktop &> /dev/null

            # create xsession for dwm
            $sudo_program sh -c "cat >>/usr/share/xsessions/dwm.desktop" <<-EOF
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic window manager
Exec=/usr/local/bin/dwm
Icon=dwm
Type=XSession
EOF

            ####################################################
            gauge=$((100 * 4 / 6)) && echo "$gauge"

            # check if pacman -Q name begins with name of ly
            # and enable its service if it is
            $sudo_program pacman -Q ly | grep -q "^ly" && $sudo_program systemctl enable ly &> /dev/null

            # set default browser to librewolf
            xdg-settings set default-web-browser librewolf.desktop &> /dev/null

            # Update the system clock
            $sudo_program timedatectl &> /dev/null
            $sudo_program timedatectl set-timezone Europe/Sarajevo &> /dev/null
            $sudo_program timedatectl set-ntp true &> /dev/null

            mkdir -p "${XDG_CACHE_HOME:-"$HOME/.cache"}"
            touch "${XDG_CACHE_HOME:-"$HOME/.cache"}"/dmenu_history 
            touch "${XDG_CACHE_HOME:-"$HOME/.cache"}"/dmenu_run 

            ####################################################
            gauge=$((100 * 5 / 6)) && echo "$gauge"

            # virtualization
            if [ "$is_virtualization" = true ]; then

                whiptail --title "VIRTUALIZATION: Warming" --yesno "You need to ensure that these are \
set to: unix_sock_group = \"libvirt\", unix_sock_ro_perms = \"0777\", and unix_sock_rw_perms = \"0770\". \
Do you want to do it now?" 10 80
                if [ $? -eq 0 ]; then
                    $sudo_program nvim /etc/libvirt/libvirtd.conf
                fi

                if systemctl status libvirtd; then
                    $sudo_program groupadd libvirt &> /dev/null
                    $sudo_program usermod -aG libvirt $(whoami) &> /dev/null
                    $sudo_program systemctl enable libvirtd &> /dev/null
                    $sudo_program systemctl restart libvirtd &> /dev/null
                fi
            fi
        )
    else
        menu
    fi
}

add_programs() {
    # Basic
    programs+=( "librewolf-bin" "htop-vim" "xclip" "curl" )

    # zsh
    programs+=( "zsh" "zsh-completions" "zsh-syntax-highlighting" "zsh-autosuggestions" )

    # Neovim
    programs+=( "neovim" "meson" "lazygit" )

    # Additional utilities
    programs+=( "atool" "zip" "unzip" "tar" "ncdu" "fzf" "maim" "feh" "ntfs-3g" )

    # sound - pipewire
    # programs+=( "pipewire" "pipewire-audio" "pipewire-alsa" )
    programs+=( "pipewire" "pipewire-audio" )

    # gui
    programs+=( "xorg-server" "xf86-video-fbdev" "ly" "redshift" "lxappearance" )


    # if whiptail --yesno "Do you want to install other things? (gaming, virtualization etc.)" 8 50; then
    #
    #     # other
    #     programs+=( "vencord-desktop-git" "gimp" )
    #     # programs+=( "libreoffice-still" "ttf-ms-fonts" )
    #
    #     # make android phones connect and transfer files
    #     # programs+=( "mtpfs" "jmtpfs" "gvfs-mtp" "gvfs-gphoto2" )
    #
    #     # gaming
    #     $sudo_program sed -i '/#[multilib]/{N;s/#\[multilib\]\n#Include = \/etc\/pacman.d\/mirrorlist/\[multilib\]\nInclude = \/etc\/pacman.d\/mirrorlist/}' /etc/pacman.conf
    #
    #     programs+=( "steam" "lutris" "wine-staging" "nvidia-dkms" "nvidia-utils-dkms" "vulkan-icd-loader" "dxvk-bin" "opencl-nvidia" "libvdpau" "libxnvctrl" "lib32-nvidia-utils" "lib32-opencl-nvidia" "lib32-vulkan-icd-loader" "proton-ge-custom-bin" "mangohud-git" "goverlay-bin" "gwe" "protonup-qt-bin" "gamemode" )
    #     
    #     # start gamemode
    #     $sudo_program systemctl --user enable gamemoded &> /dev/null
    #     $sudo_program systemctl --user start gamemoded &> /dev/null
    #     
    #     # virtualization
    #     programs+=( "qemu" "libvirt" "virt-manager" "virt-viewer" "dnsmasq" "vde2" "bridge-utils" "openbsd-netcat" "libguestfs" )
    #     is_virtualization=true
    # 
    # fi
}

install() {
    mkdir -p ~/Downloads
    mkdir -p ~/Documents
    mkdir -p ~/.cache
    add_programs

    whiptail --title "Information" --msgbox "This will take a few minutes." 7 34
    clear

    $sudo_program rm /var/lib/pacman/db.lck &> /dev/null

    # Install yeet pacman wrapper + AUR helper (package-query)
    if ! command -v yeet &> /dev/null
    then
        # whiptail --title "Installation" --gauge "\nInstalling yeet (pacman wrapper)..." 7 50 0 < <(
            $sudo_program pacman -S yajl --noconfirm
            # gauge=$((100 * 1 / 6))
            # echo "$gauge"

            # mkdir -p ~/.cache/yeet/build/
            # $sudo_program chown -R $(whoami):$(whoami) ~/.cache
            # $sudo_program chmod -R 755 ~/.cache
            # cd ~/.cache/yeet/build/
            # git clone https://aur.archlinux.org/package-query.git
            # # gauge=$((100 * 2 / 6))
            # # echo "$gauge"
            #
            # git clone https://aur.archlinux.org/yeet.git
            # # gauge=$((100 * 3 / 6))
            # # echo "$gauge"
            #
            # cd package-query
            # makepkg -sfcCi --noconfirm
            # # gauge=$((100 * 4 / 6))
            # # echo "$gauge"
            #
            # cd ../yeet
            # makepkg -sfcCi --noconfirm
            # # gauge=$((100 * 5 / 6))
            # # echo "$gauge"
            #
            # cd ~
            # edit config
            sed -i "s/\(SUDO_BIN *= *\).*/\1\/usr\/bin\/doas/" ~/.config/yeet/yeet.conf
            sed -i "s/\(PRINT_LOGO *= *\).*/\1false/" ~/.config/yeet/yeet.conf
        #)
        curl https://raw.githubusercontent.com/gamemaker1/yeet/develop/assets/package/install | bash &> /dev/null
    fi

    clear

    # Install packages
    # $sudo_program pacman -S --noconfirm desktop-file-utils &> /dev/null
    # $sudo_program update-desktop-database &> /dev/null
    # mkdir -p ~/.local/share/applications
    # echo export XDG_DATA_DIRS="$HOME/.local/share" >> ~/.bashrc
    # echo export XDG_DATA_DIRS="$HOME/.local/share" >> ~/.zshrc
    # export XDG_DATA_DIRS="$HOME/.local/share"
    export NO_CONFIRM=true

    count=1
    # whiptail --title "Program Installation" --gauge "\nInstalling various programs..." 7 50 0 < <(
        for i in "${programs[@]}"
        do
            # pipe yes because of bug in yeet
            yes '' | yeet -S $i
            #&> /dev/null
            # Update the gauge
            # count=$((count + 1))
            # gauge=$((100 * count / ${#programs[@]} + 1))
            # echo "$gauge"
        done
    # )
}

reboot_now() {
	whiptail --title "Warming" --yesno "Do you want to reboot now?" 7 40

	if [ $? -eq 0 ]; then
        $sudo_program reboot
	fi
}

# Menu window
menu() {
	CHOICE=$(
		whiptail --title "Menu" --ok-button "Select" --cancel-button "Exit" --notags --menu "\n" 10 50 2 \
		"1" "IvoryOS full installation"  \
		"2" "Configure dotfiles only" 3>&2 2>&1 1>&3
	)

	case $CHOICE in
		"1")   
			install
			configure_installed
            $sudo_program rm /etc/profile.d/firstboot.sh
			reboot_now
			;;
		"2")   
			configure_installed
			menu
			;;
	esac
}

### PROGRAM EXECUTION
$sudo_program pacman --noconfirm -Syu

# Navigation
whiptail --title "Navigation" --msgbox "Navigate lists using arrow keys. Select options with space. \
Use Tab key to navigate between the <Ok> and <Cancel> buttons." 8 80

menu

clear
exit
