#!/bin/bash

#define user account, group and current litecoin version 
LITECOIND_USER="litecoin" #the user litecoind will run under
LITECOIND_GROUP="litecoin" #the group litecoind is a member of
LITECOIN_VER="litecoin-0.8.7.5-linux" #current litecoin version

#define directory locations
HOME="/root" #home directory of the root user, we store some script and tempfiles here
LITECOIND_BIN_DIR="/home/litecoind/bin" #the directory that stores the binary file of litecoind
LITECOIND_DATA_DIR="/home/litecoind/.litecoin" #the directory that holds the litecoind data
LITECOIND_HOME_DIR="/home/litecoind" #home directory of litecoin user account

#define configuration file locations
LITECOIND_CONF_FILE="/home/litecoind/.litecoin/litecoin.conf" #the litecoind configuration file

#define download locations
SCRIPT_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/master" #the download location of the script files
WEBSITE_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/master/www" #the download location of the status page website files
LITECOIN_DL_URL="https://download.litecoin.org/litecoin-0.8.7.5/linux/litecoin-0.8.7.5-linux.tar.xz" #litecoin download link

#define test download locations. do not uncomment this unless you know what you are doing!
#SCRIPT_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/testing" #the test download location of the script files
#WEBSITE_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/testing/www" #the test download location of the status page website files

#generate random user and password for rpc
RPC_USER=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30` #this generates a random rpc username
RPC_PASSWORD=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30` #this generates a random rpc password

#change working directory
cd $HOME

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
				
				#do we want to reboot the system
				read -r -p "All done! Do you want to reboot? (Y/N) " -n 1 ANSWER
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
				mkdir -v $HOME/scripts
				
				echo "A $DIST installation script is not yet available."
                #wget $SCRIPT_DL_URL/$DIST/$DIST-install.sh -P $HOME
				#source $HOME/$DIST-install.sh
				#rm -f -v $HOME/$DIST-install.sh
								
				#do we want to reboot the system
				#read -r -p "All done! Do you want to reboot? (Y/N) " -n 1 ANSWER
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
				mkdir -v $HOME/scripts
				
				echo "A $DIST installation script is not yet available."
                #wget $SCRIPT_DL_URL/$DIST/$DIST-install.sh -P $HOME
				#source $HOME/$DIST-install.sh
				#rm -f -v $HOME/$DIST-install.sh
				
				#do we want to reboot the system
				#read -r -p "All done! Do you want to reboot? (Y/N) " -n 1 ANSWER
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
            break
            ;;
        *) echo "Invalid option.";;
    esac
done
