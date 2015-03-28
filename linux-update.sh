#!/bin/bash

#define directory locations
HOME="/root" #home directory of the root user, we store some script and tempfiles here
LITECOIND_BIN_DIR="/home/litecoind/bin" #the directory that stores the binary file of litecoind

#define test download location. do not uncomment this unless you know what you are doing!
SCRIPT_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/testing" #the test download location of the script files

#define litecoin version and download location
#SCRIPT_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/master" #the download location of the script files
LITECOIN_DL_URL="https://download.litecoin.org/litecoin-0.8.7.5/linux/litecoin-0.8.7.5-linux.tar.xz" #litecoin download link
LITECOIN_VER="litecoin-0.8.7.5-linux"

#change working directory
cd $HOME

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
