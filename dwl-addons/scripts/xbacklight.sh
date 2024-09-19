#!/bin/bash

endsh() {
    if [ "$1" = "notFound" ]
    then
        exit 1
    fi
}
trap endsh EXIT

if ! command -v xbacklight &> /dev/null
then
    endsh "notFound"
else
    if [ "$1" = "inc" ]
    then 
        xbacklight -inc 10
        exit 0
    elif [ "$1" = "dec" ]
    then 
        xbacklight -dec 10
        exit 0
    fi
fi


