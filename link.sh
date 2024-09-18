#!/bin/bash

config="desktop laptop"

echo "Enter config to link to ($config)"
read chose

for num in $config ; do 
    if [ "$num" = "$chose" ] ; then
        ln -sr config-$chose.h config.h
    fi
done
