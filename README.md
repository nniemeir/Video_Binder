# Video Binder
The purpose of this script is to allow the user to search through their local media collection with fzf. The script currently supports showing preview images for the highlighted film/show through the kitty terminal graphics protocol.

## **Demonstration**
https://github.com/nniemeir/Video_Binder/assets/91906070/86063420-07d6-4b0c-b532-ec97670a1d43
Copyrighted preview images have been omitted for legal reasons.

## **Configuration**
Video Binder must be configured before it can function as intended.

#### **Managing Preview Images**
Video Binder looks for a PNG file that has the same basename as the currently highlighted entry in the appropriate subdirectory of the images directory.

#### **Setting Media Paths**
The file *preferences.conf* contains variables that hold the paths to your shows and films.

## **Dependencies**
* [fzf](https://github.com/junegunn/fzf)
* [kitty](https://github.com/kovidgoyal/kitty)
* [mpv](https://github.com/mpv-player/mpv)

## Planned Enhancements
* Improve error handling
* Support filtering by genre
* Support other common image protocols, particularly those that support GIFs
* Support VLC
