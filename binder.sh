#!/bin/bash
# Author: Jacob Niemeir <nniemeir@protonmail.com>
promptMediaType() {
clear
mediaType=$(echo -e "Films\nTelevision" | fzf --delimiter , --with-nth -1 --height=80% --padding=5,40,0,40 --layout=reverse --cycle --prompt="Select Media Type: " --preview='
file_path=images/video_types/{}
file_name="${file_path%.*}"
preview_file="${file_name}.png"
if [ -e "$preview_file" ]; then
  kitty icat --clear --transfer-mode=stream --stdin=no --place=40x40@20x20 "$preview_file"
else
  kitty icat --clear --transfer-mode=stream --stdin=no --place=40x40@20x20 "images/error.png"
fi
' --preview-window noborder,up,30)

if [ "$mediaType" == "Films" ]; then
	promptVideo
elif [ "$mediaType" == "Television" ]; then
	promptTV
else
	kitty icat --clear
	clear
	exit 0
fi
}

promptTV() {
clear
showSelection=$(ls $SHOWS_PATH | fzf --delimiter , --with-nth -1 --height=80% --padding=5,40,0,40 --layout=reverse --cycle --prompt="Select Program: " --preview='
file_path=images/shows/{}
preview_file="${file_path}.png"

if [ -e "$preview_file" ]; then
  kitty icat --clear --transfer-mode=stream --stdin=no --place=40x40@20x20 "$preview_file"
else
  kitty icat --clear --transfer-mode=stream --stdin=no --place=40x40@20x20 "images/error.png"
fi
' --preview-window noborder,up,30)

export showSelection

if [ -z "$showSelection" ]; then
	promptMediaType
else
	promptSeason
fi
}

promptSeason() {
clear
seasonSelection=$(ls "$SHOWS_PATH/$showSelection" | fzf --delimiter , --with-nth -1 --height=80% --padding=5,40,0,40 --layout=reverse --cycle --prompt="Select Season: " --preview='
preview_file="images/shows/${showSelection}.png"
if [ -e "$preview_file" ]; then
  kitty icat --clear --transfer-mode=stream --stdin=no --place=40x40@20x20 "$preview_file"
else
  kitty icat --clear --transfer-mode=stream --stdin=no --place=40x40@20x20 "images/error.png"
fi
' --preview-window noborder,up,30)

if [ -z "$seasonSelection" ]; then
	promptTV
else
	promptEpisode
fi
}

promptEpisode() {
clear
videoFiles=$(ls "$SHOWS_PATH/$showSelection/$seasonSelection/"*.{mkv,mp4} 2>/dev/null)
episodeSelection=$(echo "$videoFiles" | xargs -I {} basename "{}" | sed 's/\.[^.]*$//' | fzf --delimiter , --with-nth -1 --height=80% --padding=5,40,0,40 --layout=reverse --cycle --prompt="Select Episode: " --preview='
preview_file="images/shows/${showSelection}.png"
if [ -e "$preview_file" ]; then
  kitty icat --clear --transfer-mode=stream --stdin=no --place=40x40@20x20 "$preview_file"
else
  kitty icat --clear --transfer-mode=stream --stdin=no --place=40x40@20x20 "images/error.png"
fi
' --preview-window noborder,up,30)
if [ -z "$episodeSelection" ]; then
	promptSeason
else
	mpv "$SHOWS_PATH/$showSelection/$seasonSelection/$episodeSelection".* --fullscreen > /dev/null 2>&1 &
fi
}


promptVideo() {
# Add any other extensions if present in your library
videoFiles=$(ls "$MOVIES_PATH/"*.{mkv,mp4} 2>/dev/null)
clear

# Create the primary and preview fzf window
videoSelection=$(echo "$videoFiles" | xargs -I {} basename "{}" | sed 's/\.[^.]*$//' | fzf --height=80% --padding=5,40,0,40 --layout=reverse --cycle --prompt="Select Film: " --preview='
file_path=images/films/{}
file_name="${file_path%.*}"
preview_file="${file_name}.png"
if [ -e "$preview_file" ]; then
  kitty icat --clear --transfer-mode=stream --stdin=no --place=40x40@20x20 "$preview_file"
else
  kitty icat --clear --transfer-mode=stream --stdin=no --place=40x40@20x20 "images/error.png"
fi
' --preview-window noborder,up,30)

kitty icat --clear
clear
if [ -z "$videoSelection" ]; then
	promptMediaType
else

mpv "$MOVIES_PATH/$videoSelection".* --fullscreen > /dev/null 2>&1 &
fi
}

preview_file=""

# Ensure configuration file is present
source preferences.conf || {
	echo "Error: No configuration file found."
	exit 1
}

# Ensure script is being run in kitty
if [ "$TERM" != "xterm-kitty" ]; then
	echo "This script must be run in kitty terminal"
fi

# Ensure fzf is installed
command -v fzf >/dev/null 2>&1 || {
	echo >&2 "Error: fzf not found"
	exit 1
}

promptMediaType
kitty icat --clear
clear
exit 0
