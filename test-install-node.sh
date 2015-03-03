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
UPSTART_CONF_DIR="/etc/init" #the directory that holds the litecoind upstart configuration file
WEBSITE_DIR="/usr/share/nginx/html" #the directory that stores the http status page files

#define configuration file locations
LITECOIND_CONF_FILE="/home/litecoind/.litecoin/litecoin.conf" #the litecoind configuration file
UPSTART_CONF_FILE="litecoind.conf" #name of the litecoind upstart script config file. This is not the litecoin.conf file!

#define download locations
UPSTART_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/master/litecoind.conf" #the download location of the upstart.conf file for litecoind
WEBSITE_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/master" #the download location of the status page website files
NODESTATUS_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/master/nodestatus.py" #the download location of the nodestatus.py file
LITECOIN_DL_URL="https://download.litecoin.org/litecoin-0.8.7.5/linux/litecoin-0.8.7.5-linux.tar.xz" #litecoin download link

#generate random user and password for rpc
RPC_USER=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30` #this generates a random rpc username
RPC_PASSWORD=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30` #this generates a random rpc password

#change working directory
cd $HOME

mkdir -v $HOME/scripts 

#do we want to install system updates
read -r -p "Do you want to install operating system updates? (Y/N) " -n 1 ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
    wget $WEBSITE_DL_URL/test-install-updates.sh -P $HOME
	source $HOME/test-install-updates.sh
	rm -f -v $HOME/test-install-updates.sh
fi

#do we want to install Litecoin
read -r -p "Do you want to install Litecoin? (Y/N) " -n 1 ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
    wget $WEBSITE_DL_URL/test-install-litecoin.sh -P $HOME
	source $HOME/test-install-litecoin.sh
	rm -f -v $HOME/test-install-litecoin.sh
fi

#do we want to install system the node status http page
read -r -p "Do you want to install the node status http page? (Y/N) " -n 1 ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
    wget $WEBSITE_DL_URL/test-install-nodestatus.sh -P $HOME
	source $HOME/test-install-nodestatus.sh
	rm -f -v $HOME/test-install-nodestatus.sh
fi

#do we want to create a swap file
read -r -p "Do you want to create a swap file? (Y/N) " -n 1 ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
    wget $WEBSITE_DL_URL/test-install-createswap.sh -P $HOME
	source $HOME/test-install-createswap.sh
	rm -f -v $HOME/test-install-createswap.sh
fi

#do we want to reboot the system
read -r -p "All done! Do you want to reboot? (Y/N) " -n 1 ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
    shutdown -r 1 Press CTRL+C to abort.
fi

#we are done. exit the script
exit
