#!/bin/bash

#define directory locations
UPSTART_CONF_DIR="/etc/init" #the directory that holds the litecoind upstart configuration file
WEBSITE_DIR="/usr/share/nginx/html" #the directory that stores the http status page files

#define configuration file locations
UPSTART_CONF_FILE="litecoind.conf" #name of the litecoind upstart script config file. This is not the litecoin.conf file!

#define download locations
UBUNTU_BASE="$SCRIPT_DL_URL/$DIST" #base directory for ubuntu script files
UPSTART_DL_URL="$UBUNTU_BASE/litecoind.conf" #the download location of the upstart.conf file for litecoind

#change working directory
cd $HOME

#update package repository
apt-get update -y

#do we want to install system updates
read -r -p "Do you want to install operating system updates? (Y/N) " ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
	#update operating system
	echo "Performing operating system updates"
	apt-get upgrade -y
fi

#do we want to install Litecoin
read -r -p "Do you want to install Litecoin? (Y/N) " ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
	wget $UBUNTU_BASE/$DIST-install-litecoin.sh -P $HOME
	source $HOME/$DIST-install-litecoin.sh
	rm -f -v $HOME/$DIST-install-litecoin.sh
	
		read -r -p "Do you want to install the Litecoin automatic update script? (Y/N) " ANSWER
		echo
		if [[ $ANSWER =~ ^([yY])$ ]]
		then
			#download the update script
			echo "Downloading the update script."
			wget $UBUNTU_BASE/$DIST-update.sh -P $HOME/scripts
			chmod -R 0700 $HOME/scripts/$DIST-update.py
			chown -R root:root $HOME/scripts/$DIST-update.py
			
			#download the version file
			echo "Downloading the version file."
			wget $SCRIPT_DL_URL/shared/version -P $HOME/scripts
			chmod -R 0600 $HOME/scripts/version
			chown -R root:root $HOME/scripts/version

			#add the update script to cron and run it every sunday
			echo "Add the update script to cron and run it every sunday"
			echo "45 23 * * 7 /usr/bin/bash $HOME/scripts/ubuntu-update.sh" >> /$HOME/scripts/crontempfile
			crontab $HOME/scripts/crontempfile
			rm $HOME/scripts/crontempfile
	fi
fi

#do we want to install the http status page
read -r -p "Do you want to install the http status page? (Y/N) " ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
	wget $UBUNTU_BASE/$DIST-install-statuspage.sh -P $HOME
	source $HOME/$DIST-install-statuspage.sh
	rm -f -v $HOME/$DIST-install-statuspage.sh
fi

#do we want to create a swap file
read -r -p "Do you want to create a swap file? (Y/N) " ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
	wget $UBUNTU_BASE/$DIST-install-createswap.sh -P $HOME
	source $HOME/$DIST-install-createswap.sh
	rm -f -v $HOME/$DIST-install-createswap.sh
fi
