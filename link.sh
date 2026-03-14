#!/bin/bash

config="desktop"

echo "Enter config to link to ($config)"
read -r chose

for num in $config ; do 
    if [ "$num" = "$chose" ] ; then
        ln -sr "config-$chose.h" config.h
    fi
done
