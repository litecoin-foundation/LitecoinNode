#!/bin/bash

cd $HOME

echo "Detect if a swap file exists and create one if this is not the case" #this needs more testing
TOTAL_RAM=`awk '/MemTotal/{print $2}' /proc/meminfo` #get current system memory to base swap size on
if free | awk '/^Swap:/ {exit !$2}'; then
    echo "Skip creation of swap it already exists!"
else
    dd if=/dev/zero of=/swapfile bs=1M count=$TOTAL_RAM ; mkswap /swapfile ; swapon /swapfile
	echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
	echo "Created swapfile!"
fi
