#!/bin/bash

#load global variables file
wget --progress=bar:force -q https://raw.githubusercontent.com/litecoin-association/LitecoinNode/master/glob-vars.sh -P /root
source /root/glob-vars.sh
rm -f -v /root/glob-vars.sh

#change working directory
cd $HOME
clear

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
	wget --progress=bar:force $RASPBIAN_BASE/$DIST-install-litecoin.sh -P $HOME
	source $HOME/$DIST-install-litecoin.sh
	rm -f -v $HOME/$DIST-install-litecoin.sh

		read -r -p "Do you want to install the Litecoin automatic update script? (Y/N) " ANSWER
		echo
		if [[ $ANSWER =~ ^([yY])$ ]]
		then

			read -r -p "WARNING: Automatically running untrusted code from the internet can be dangerous, are you sure you want to continue? (Y/N) " ANSWER
			echo
			if [[ $ANSWER =~ ^([yY])$ ]]
			then

				#download the update script
				echo "Downloading the update script."
				wget --progress=bar:force $RASPBIAN_BASE/$DIST-update.sh -P $HOME/scripts
				chmod -R 0700 $HOME/scripts/$DIST-update.sh
				chown -R root:root $HOME/scripts/$DIST-update.sh

				#download the version file
				echo "Downloading the version file."
				wget --progress=bar:force $SCRIPT_DL_URL/shared/version -P $HOME/scripts
				chmod -R 0600 $HOME/scripts/version
				chown -R root:root $HOME/scripts/version

				#add the update script to cron and run it every sunday
				echo "Add the update script to cron and run it every sunday"
				crontab -l > $HOME/scripts/crontempfile
				echo "45 23 * * * /usr/bin/bash $HOME/scripts/raspbian-update.sh" >> /$HOME/scripts/crontempfile
				crontab $HOME/scripts/crontempfile
				rm $HOME/scripts/crontempfile
		fi
	fi
fi

#do we want to install the http status page
read -r -p "Do you want to install the http status page? (Y/N) " ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
	wget --progress=bar:force $RASPBIAN_BASE/$DIST-install-statuspage.sh -P $HOME
	source $HOME/$DIST-install-statuspage.sh
	rm -f -v $HOME/$DIST-install-statuspage.sh
fi

#do we want to create a swap file
read -r -p "Do you want to create a swap file? (Y/N) " ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
	wget --progress=bar:force $RASPBIAN_BASE/$DIST-install-createswap.sh -P $HOME
	source $HOME/$DIST-install-createswap.sh
	rm -f -v $HOME/$DIST-install-createswap.sh
fi
