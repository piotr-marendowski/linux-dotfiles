#!/usr/bin/env bash
# Install script for dotfiles (wayland version)
# Author: Piotr Marendowski (https://github.com/piotr-marendowski)
# License: GPL3

is_virtualization=false     # is virtualization enabled? 
programs=()
dotfiles_dir=~/Downloads/dotfiles
config_dir=~/.config
cache_dir=~/.cache

# check for sudo program
if command -v doas &> /dev/null
then
    sudo_program=doas
else
    sudo_program=sudo
fi

yes_no() {
   while true; do
       read -n 1 -p "$* [Y/n]: " yn
       case $yn in
           [Yy]*) return 0 ;; 
           [Nn]*) return 1 ;;
           '')    return 1 ;;
       esac
   done
}

# args: first number, length, process string
progress_bar() {
	let progress=(${1}*100/${2}*100)/100
	let done=(${progress}*4)/10
	let left=40-$done

    # Build progressbar string lengths
	done=$(printf "%${done}s")
	left=$(printf "%${left}s")

    # Print progress bar with which program is installing
    printf "\r%*s\r%s\n" "$COLUMNS" "[${done// /#}${left// /-}] ${progress}%" "${3}"
}

configure_installed() {
    yes_no ":: Do you want to configure dotfiles?" && {
        # Make zsh default shell
        yes_no ":: Do you want to make zsh default shell?" && {
            $sudo_program chsh -s /usr/bin/zsh &> /dev/null
            $sudo_program chsh -s /bin/zsh &> /dev/null
        }
        
        progress_bar 1 5 "(1/5) configuring system"

        # Pull environment-agnostic dotfiles (nvim etc.)
        cd $dotfiles_dir
        cd ../
        git clone https://github.com/piotr-marendowski/dotfiles.git dotfiles2
        # Move all files from dotfiles2 to $dotfiles_dir
        mv -f dotfiles2/{.,}* $dotfiles_dir

        # Move dotfiles to home
        cp -a $dotfiles_dir/. ~ &> /dev/null

        # edit yeet's config
        mkdir -p $config_dir/yeet/ &> /dev/null
        touch $config_dir/yeet/yeet.conf &> /dev/null
        sed -i "s/\(SUDO_BIN *= *\).*/\1\/usr\/bin\/doas/" $config_dir/yeet/yeet.conf &> /dev/null
        sed -i "s/\(PRINT_LOGO *= *\).*/\1false/" $config_dir/yeet/yeet.conf &> /dev/null

        ####################################################
        progress_bar 2 5 "(2/5) configuring system"

        # install fff file manager
        cd ~/Downloads
        git clone https://github.com/piotr-marendowski/fff &> /dev/null
        cd fff
        $sudo_program make install &> /dev/null

        # move wallpaper to $config_dir
        cp $dotfiles_dir/assets/wallpaper.jpg $config_dir &> /dev/null

        # delete unnecessary items
        $sudo_program rm -r ~/assets &> /dev/null
        $sudo_program rm -r ~/install.sh &> /dev/null
        $sudo_program rm -r ~/LICENSE &> /dev/null
        $sudo_program rm -r ~/README.md &> /dev/null
        $sudo_program rm -r $config_dir/.config/ &> /dev/null
        $sudo_program rm -r ~/.git/ &> /dev/null

        ####################################################
        progress_bar 3 5 "(3/5) configuring system"

        # Dowload FiraCode Nerd Font and install it
        $sudo_program mkdir -p /usr/share/fonts/TTF/ &> /dev/null
        cd /usr/share/fonts/TTF/
        $sudo_program curl -fLo "FiraCode Nerd Font Regular.ttf" \
        "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf" &> /dev/null

        # configure dwl
        cd $config_dir/dwl/ &> /dev/null
        $sudo_program make install &> /dev/null

        ####################################################
        progress_bar 4 5 "(4/5) configuring system"

        # check if pacman -Q name begins with name of ly
        # and enable its service if it is
        $sudo_program pacman -Q ly | grep -q "^ly" && $sudo_program systemctl enable ly &> /dev/null

        # set default browser to librewolf
        xdg-settings set default-web-browser librewolf.desktop &> /dev/null

        # Update the system clock
        $sudo_program timedatectl &> /dev/null
        $sudo_program timedatectl set-timezone Europe/Sarajevo &> /dev/null
        $sudo_program timedatectl set-ntp true &> /dev/null

        #touch ~/.cache/dmenu_history &> /dev/null
        #touch ~/.cache/dmenu_run &> /dev/null

        ####################################################
        progress_bar 5 5 "(5/5) configuring system"

        # virtualization
        if [ "$is_virtualization" = true ]; then

            printf "You need to set: unix_sock_group = \"libvirt\", unix_sock_ro_perms = \"0777\", and unix_sock_rw_perms = \"0770\".\n"

            yes_no "Do you want to do it now?" && {
                $sudo_program nvim /etc/libvirt/libvirtd.conf

                if systemctl status libvirtd; then
                    $sudo_program groupadd libvirt &> /dev/null
                    $sudo_program usermod -aG libvirt $(whoami) &> /dev/null
                    $sudo_program systemctl enable libvirtd &> /dev/null
                    $sudo_program systemctl restart libvirtd &> /dev/null
                fi
            }
        fi
    } || return

    clear
    printf "Configuration complete!\n"
}

add_programs() {
    # Basic
    programs+=( "librewolf-bin" "foot" "htop-vim" "curl" )

    # zsh
    programs+=( "zsh" "zsh-completions" "zsh-syntax-highlighting" "zsh-autosuggestions" )

    # Neovim
    programs+=( "neovim" "meson" "lazygit" )

    # Additional utilities
    programs+=( "atool" "zip" "unzip" "tar" "ncdu" "ntfs-3g" )

    # sound - pipewire
    programs+=( "pipewire" "pipewire-audio" )

    # gui
    programs+=( "wayland" "libinput" "wlroots" "libxkbcommon" "wayland-protocols" "libxcb" "xorg-xwayland" "ly" )

    # Drivers and gaming
    yes_no ":: Do you want to install other things (gaming, virtualization etc.)?" && {
        # Other
        echo "gaming"

        # Check for GPU and add drivers for it
        if lspci | grep VGA | grep -q 'AMD'; then
            # AMD
            programs+=( "mesa" "vulkan-radeon" "lib32-mesa vulkan-radeon" "lib32-vulkan-radeon" "libva-mesa-driver" )
        else
            # Nvidia
            programs+=( "nvidia-dkms" "nvidia-utils-dkms" "opencl-nvidia" "libvdpau" "libxnvctrl" "lib32-nvidia-utils" "lib32-opencl-nvidia" "gwe" )
        fi

        # Gaming
        # "protonup-qt-bin"
        programs+=( "steam" "lutris" "wine-staging" "vulkan-icd-loader" "lib32-vulkan-icd-loader" "dxvk-bin" "proton-ge-custom-bin" "mangohud" "gamemode" )
        
        # virtualization
        programs+=( "qemu-base" "libvirt" "virt-manager" "virt-viewer" "dnsmasq" "vde2" "bridge-utils" "openbsd-netcat" "libguestfs" )
        is_virtualization=true
    }
}

install() {
    clear
    mkdir -p ~/Documents
    mkdir -p $cache_dir
    mkdir -p $config_dir
    add_programs
    clear

    printf ":: ${#programs[@]} packages to be installed:\n"
    printf "%s   " "${programs[@]}"
    printf "\n"

    read -p ":: This will take a few minutes "
    clear

    # Install yeet pacman wrapper + AUR helper (package-query)
    if ! command -v yeet &> /dev/null
    then
        progress_bar 1 5 "(1/5) installing yeet (pacman wrapper)"

        $sudo_program pacman -S yajl --noconfirm &> /dev/null
        
        progress_bar 2 5 "(2/5) installing yeet (pacman wrapper)"

        mkdir -p $cache_dir/yeet/build/ &> /dev/null
        cd $cache_dir/yeet/build/
        git clone https://aur.archlinux.org/package-query.git &> /dev/null

        progress_bar 3 5 "(3/5) installing yeet (pacman wrapper)"

        git clone https://aur.archlinux.org/yeet.git &> /dev/null
        
        progress_bar 4 5 "(4/5) installing yeet (pacman wrapper)"

        cd package-query
        makepkg -sfcCi --noconfirm &> /dev/null
        
        progress_bar 5 5 "(5/5) installing yeet (pacman wrapper)"

        cd ../yeet
        makepkg -sfcCi --noconfirm &> /dev/null
    fi

    # edit config
    sed -i "s/\(SUDO_BIN *= *\).*/\1\/usr\/bin\/doas/" $config_dir/yeet/yeet.conf &> /dev/null
    sed -i "s/\(PRINT_LOGO *= *\).*/\1false/" $config_dir/yeet/yeet.conf &> /dev/null

    # Install packages
    clear
    export NO_CONFIRM=true

    start=0
    end=${#programs[@]}

    for ((i=$start; i<=$end; i++))
    do
        clear
        progress_bar $((i+1)) ${end} "(${i}/${#programs[@]}) installing ${programs[i]}"
        yeet -S ${programs[i]}
    done
}

$sudo_program pacman --noconfirm -Syu
clear

while true; do
    printf ":: There are 4 options in dotfiles:\n"
    printf ":: Options\n"
    printf "   1) ivoryOS setup  2) install only  3) configure only  q) quit\n\n"

    read -n 1 -p "Enter a selection (default=quit): " ans
    case $ans in
        1*)
            install
            clear
            configure_installed
            clear
            printf "Installation complete!\n"
            $sudo_program rm /etc/profile.d/firstboot.sh
            yes_no ":: Reboot system?" && echo "reboot"
            ;;
        2*)
            install
            clear
            printf "Installation complete!\n"
            yes_no ":: Reboot system?" && echo "reboot"
            ;;
        3*)
            clear
            configure_installed
            clear
            ;;
        'q'|'') break;;
    esac
done

