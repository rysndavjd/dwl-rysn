#!/bin/bash

#image_path="./dwl-addons/wallpapers"
image_path="/usr/share/dwl-rysn/wallpapers"

wallpapers=()

for images in "$image_path"/* ; do
    wallpapers+=("$images")
done

if ! pgrep wbg ; then
    pkill wbg
    wallpaper=${wallpapers[ $RANDOM % ${#wallpapers[@]} ]}
    exec wbg "$wallpaper"
else
    wallpaper=${wallpapers[ $RANDOM % ${#wallpapers[@]} ]}
    exec wbg "$wallpaper"
fi

