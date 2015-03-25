#!/bin/bash

#change working directory
cd $HOME

#update operating system
echo "Performing operating system updates"
apt-get upgrade -y
