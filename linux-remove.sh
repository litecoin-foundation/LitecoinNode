#!/bin/bash

#load global variables file
wget -q https://raw.githubusercontent.com/litecoin-association/LitecoinNode/master/glob-vars.sh -P /root
source /root/glob-vars.sh
rm -f -v /root/glob-vars.sh

#change working directory
cd $HOME
clear

echo ""
echo "-----------------------------------------------------------------------"
echo ""
echo "Welcome to the Litecoin node remove script."
echo "This script will remove the Litecoin full node from your computer."
echo "We will ask you some questions do determine what we need to do."
echo "To start the removal select your Linux distribution from the menu."
echo "For more information or help visit http://litecoinnode.org"
echo ""
echo "-----------------------------------------------------------------------"
echo ""

#create operating system choice menu
PS3="Please select your choice: "
CHOICE=("Ubuntu" "Debian" "CentOS" "Exit")
select CHC in "${CHOICE[@]}"
do
	case $CHC in
		"Ubuntu")
				#define distribution
				DIST="ubuntu"
				
				wget $SCRIPT_DL_URL/$DIST/$DIST-remove.sh -P $HOME
				source $HOME/$DIST-remove.sh
				rm -f -v $HOME/$DIST-remove.sh
				rm -f -v $HOME/linux-remove.sh
								
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
				
				wget $SCRIPT_DL_URL/$DIST/$DIST-remove.sh -P $HOME
				source $HOME/$DIST-remove.sh
				rm -f -v $HOME/$DIST-remove.sh
				rm -f -v $HOME/linux-remove.sh
				
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
		"CentOS")
				#define distribution
				DIST="centos"
				
				echo "A $DIST removal script is not yet available."
				#wget $SCRIPT_DL_URL/$DIST/$DIST-remove.sh -P $HOME
				#source $HOME/$DIST-remove.sh
				#rm -f -v $HOME/$DIST-remove.sh				
				#rm -f -v $HOME/linux-remove.sh
				
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
				rm -f /root/linux.sh
				rm -f /$HOME/linux-remove.sh
				break
			;;
		*) echo "Invalid option.";;
	esac
done
