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

# Menu window

# Sound

# 

# Necessary
install "Web Browsers" "Select one or more web browsers to install.\nAll programs marked with '*' are already installed.\nUnselecting them will NOT uninstall them." \
"brave" "chromium" "firefox" "librewolf" "qutebrowser" ""

# GUI
#
# Look and feel
#
install "Other Internet Programs" "Other Internet programs available for installation.\nAll programs marked with '*' are already installed.\nUnselecting them will NOT uninstall them." "discord-canary" ""

# Multimedia
install "Multimedia Programs" "Multimedia programs available for installation.\nAll programs marked with '*' are already installed.\nUnselecting them will NOT uninstall them." "gimp" "" "inkscape" "" "kdenlive" "" "krita" "" "mpv" "" "obs-studio" "obs" "rhythmbox" "" "ristretto" "" "vlc" ""

# Office
install "Office Programs" "Office and productivity programs available for installation.\nAll programs marked with '*' are already installed.\nUnselecting them will NOT uninstall them." "abiword" "" "evince" "" "gnucash" "" "gnumeric" "" "libreoffice-fresh" "lowriter" "libreoffice-still" "lowriter" "scribus" "" "zathura" ""

# Games
install "Games" "Gaming programs available for installation.\nAll programs marked with '*' are already installed.\nUnselecting them will NOT uninstall them." "0ad" "" "gnuchess" "" "lutris" "" "neverball" "" "openarena" "" "steam" "" "supertuxkart" "" "sauerbraten" "sauerbraten-client" "teeworlds" "" "veloren-bin" "veloren" "wesnoth" "" "xonotic" "xonotic-glx"
