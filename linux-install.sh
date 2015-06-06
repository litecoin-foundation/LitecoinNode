#!/bin/bash

#load global variables file
wget -q https://raw.githubusercontent.com/litecoin-association/LitecoinNode/master/glob-vars.sh -P /root
source /root/glob-vars.sh
rm -f -v /root/glob-vars.sh

#change working directory
cd $HOME
clear

#create operating system choice menu
echo ""
echo "-----------------------------------------------------------------------"
echo ""
echo "Welcome to the Litecoin node installation script."
echo "This script will install a Litecoin full node on your computer."
echo "During the installation the script will ask you some questions."
echo "To start the installation select your Linux distribution from the menu."
echo "For more information or help visit http://litecoinnode.org."
echo ""
echo "-----------------------------------------------------------------------"
echo ""

PS3="Please select your choice: "
CHOICE=("Ubuntu" "Debian" "CentOS" "Exit")
select CHC in "${CHOICE[@]}"
do
	case $CHC in
		"Ubuntu")
				#define distribution
				DIST="ubuntu"

				#make scripts directory
				mkdir -v $HOME/scripts

				wget $SCRIPT_DL_URL/$DIST/$DIST-install.sh -P $HOME
				source $HOME/$DIST-install.sh
				rm -f -v $HOME/$DIST-install.sh
				rm -f -v $HOME/linux-install.sh

				#do we want to reboot the system
				read -r -p "All done! Do you want to reboot? (Y/N) " ANSWER
				echo
				if [[ $ANSWER =~ ^([yY])$ ]]
				then
					shutdown -r 1 Press CTRL+C to abort.
				fi

				#we are done. exit the script
				exit
			;;
		"Debian")
				#define distribution
				DIST="debian"

				#make scripts directory
				#mkdir -v $HOME/scripts

				echo "A $DIST installation script is not yet available."
				#wget $SCRIPT_DL_URL/$DIST/$DIST-install.sh -P $HOME
				#source $HOME/$DIST-install.sh
				#rm -f -v $HOME/$DIST-install.sh
				#rm -f -v $HOME/linux-install.sh

				#do we want to reboot the system
				#read -r -p "All done! Do you want to reboot? (Y/N) " ANSWER
				#echo
				#if [[ $ANSWER =~ ^([yY])$ ]]
				#then
				#	shutdown -r 1 Press CTRL+C to abort.
				#fi

				#we are done. exit the script
				#exit
			;;
		"CentOS")
				#define distribution
				DIST="centos"

				#make scripts directory
				#mkdir -v $HOME/scripts

				echo "A $DIST installation script is not yet available."
				#wget $SCRIPT_DL_URL/$DIST/$DIST-install.sh -P $HOME
				#source $HOME/$DIST-install.sh
				#rm -f -v $HOME/$DIST-install.sh
				#rm -f -v $HOME/linux-install.sh

				#do we want to reboot the system
				#read -r -p "All done! Do you want to reboot? (Y/N) " ANSWER
				#echo
				#if [[ $ANSWER =~ ^([yY])$ ]]
				#then
				#	shutdown -r 1 Press CTRL+C to abort.
				#fi

				#we are done. exit the script
				#exit
			;;
		"Exit")
				echo ""
				rm -f /root/linux.sh
				rm -f /$HOME/linux-install.sh
				break
			;;
		*) echo "Invalid option.";;
	esac
done
