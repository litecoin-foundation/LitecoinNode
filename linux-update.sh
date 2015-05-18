#!/bin/bash

#load global variables file
wget -q http://orange.litecoinnode.org/tests/glob-vars.sh -P /root
source /root/glob-vars.sh
rm -f -v /root/glob-vars.sh

#change working directory
cd $HOME
clear

#create operating system choice menu
echo ""
echo "-----------------------------------------------------------------------"
echo ""
echo "Welcome to the Litecoin node update script."
echo "This script will update the Litecoin full node on your computer."
echo "To start the update select your Linux distribution from the menu."
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
				
				wget $SCRIPT_DL_URL/$DIST/$DIST-update.sh -P $HOME
				source $HOME/$DIST-update.sh
				rm -f -v $HOME/$DIST-update.sh
				rm -f -v $HOME/linux-update.sh
								
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
				
				echo "A $DIST update script is not yet available."
				#wget $SCRIPT_DL_URL/$DIST/$DIST-update.sh -P $HOME
				#source $HOME/$DIST-update.sh
				#rm -f -v $HOME/$DIST-update.sh
				#rm -f -v $HOME/linux-update.sh
				
				#do we want to reboot the system
				#read -r -p "All done! Do you want to reboot? (Y/N) " ANSWER
				#echo
				#if [[ $ANSWER =~ ^([yY])$ ]]
				#then
				#	shutdown -r 1 Press CTRL+C to abort.
				#fi
				#
				#we are done. exit the script
				#exit
			;;
		"CentOS")
				#define distribution
				DIST="centos"
				
				echo "A $DIST update script is not yet available."
				#wget $SCRIPT_DL_URL/$DIST/$DIST-update.sh -P $HOME
				#source $HOME/$DIST-update.sh
				#rm -f -v $HOME/$DIST-update.sh				
				#rm -f -v $HOME/linux-update.sh
				
				#do we want to reboot the system
				#read -r -p "All done! Do you want to reboot? (Y/N) " ANSWER
				#echo
				#if [[ $ANSWER =~ ^([yY])$ ]]
				#then
				#	shutdown -r 1 Press CTRL+C to abort.
				#fi
				#
				#we are done. exit the script
				#exit
			;;
		"Exit")
				echo ""
				break
			;;
		*) echo "Invalid option.";;
	esac
done
