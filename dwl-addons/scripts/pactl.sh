#!/bin/bash

endsh() {
    exit 1
}

if ! command -v pactl &> /dev/null
then
    endsh
else
    if [ "$1" = "inc" ]
    then
        pactl -- set-sink-volume 0 +10%
        exit 0
    elif [ "$1" = "dec" ]
    then
        pactl -- set-sink-volume 0 -10%
        exit 0
    elif [ "$1" = "mute" ]
    then
        if [ $(pactl get-sink-mute @DEFAULT_SINK@) = "Mute: no" ]
        then
            pactl set-sink-mute @DEFAULT_SINK@ yes
            exit 0
        elif [ $(pactl get-sink-mute @DEFAULT_SINK@) = "Mute: yes" ]
        then
            pactl set-sink-mute @DEFAULT_SINK@ no
            exit 0
        fi
    fi
fi


