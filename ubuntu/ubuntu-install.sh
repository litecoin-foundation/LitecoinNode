#!/bin/bash

#define directory locations
UPSTART_CONF_DIR="/etc/init" #the directory that holds the litecoind upstart configuration file
WEBSITE_DIR="/usr/share/nginx/html" #the directory that stores the http status page files

#define configuration file locations
UPSTART_CONF_FILE="litecoind.conf" #name of the litecoind upstart script config file. This is not the litecoin.conf file!

#define download locations
UBUNTU_BASE="$SCRIPT_DL_URL/$DIST" #base directory for ubuntu script files
UPSTART_DL_URL="$UBUNTU_BASE/litecoind.conf" #the download location of the upstart.conf file for litecoind
NODESTATUS_DL_URL="$UBUNTU_BASE/$DIST-nodestatus.py" #the download location of the nodestatus.py file

#change working directory
cd $HOME

#update package repository
apt-get update -y

#do we want to install system updates
read -r -p "Do you want to install operating system updates? (Y/N) " -n 1 ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
    wget $UBUNTU_BASE/$DIST-install-osupdate.sh -P $HOME
	source $HOME/$DIST-install-osupdate.sh
	rm -f -v $HOME/$DIST-install-osupdate.sh
fi

#do we want to install Litecoin
read -r -p "Do you want to install Litecoin? (Y/N) " -n 1 ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
    wget $UBUNTU_BASE/$DIST-install-litecoin.sh -P $HOME
	source $HOME/$DIST-install-litecoin.sh
	rm -f -v $HOME/$DIST-install-litecoin.sh
fi

#do we want to install the http status page
read -r -p "Do you want to install the http status page? (Y/N) " -n 1 ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
    wget $UBUNTU_BASE/$DIST-install-statuspage.sh -P $HOME
	source $HOME/$DIST-install-statuspage.sh
	rm -f -v $HOME/$DIST-install-statuspage.sh
fi

#do we want to create a swap file
read -r -p "Do you want to create a swap file? (Y/N) " -n 1 ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
    wget $UBUNTU_BASE/$DIST-install-createswap.sh -P $HOME
	source $HOME/$DIST-install-createswap.sh
	rm -f -v $HOME/$DIST-install-createswap.sh
fi
