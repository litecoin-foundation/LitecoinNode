#!/bin/bash

#define directory locations
UPSTART_CONF_DIR="/etc/init" #the directory that holds the litecoind upstart configuration file
WEBSITE_DIR="/usr/share/nginx/html" #the directory that stores the http status page files

#define configuration file locations
UPSTART_CONF_FILE="litecoind.conf" #name of the litecoind upstart script config file. This is not the litecoin.conf file!

#define download locations
UBUNTU_BASE="https://raw.githubusercontent.com/litecoin-association/LitecoinNode/master/$DIST" #base directory for ubuntu script files
UPSTART_DL_URL="$UBUNTU_BASE/litecoind.conf" #the download location of the upstart.conf file for litecoind
NODESTATUS_DL_URL="$UBUNTU_BASE/$DIST-nodestatus.py" #the download location of the nodestatus.py file

#array for nodes
array=("ltc.1001bitcoins.com", "supernode-02.hashfaster.com", "ltc.block-explorer.com", "192.241.134.130", "198.27.97.187", "ltc.9mmo.com", "ltcsupernode.cafecode.com", "ltc.commy.org", "p2pool.cryptogeeks.com", "195.154.14.72", "cryptochart.com", "37.139.3.160", "super.sw.gy", "supernode-03.hashfaster.com", "litecointools.com", "72.26.202.244", "192.241.166.112", "supernode-2.give-me-coins.com", "lites.pw", "37.187.3.125", "ltc.lurkmore.com", "pool.ltc4u.net", "46.105.96.190", "ltc.lfcvps.com", "supernode-01.hashfaster.com", "supernode-ltc.litetree.com", "54.234.44.180", "ottrbutt.com", "95.85.28.149", "54.204.67.137", "ltc.serversresort.com", "162.243.254.90", "195.154.12.243", "supernode-3.give-me-coins.com", "192.241.193.227", "109.201.133.197", "198.199.103.138")
RANDOM=$$$(date +%s)
selectedarray=${array[$RANDOM % ${#array[@]} ]}
selectedarray_two=${array[$RANDOM % ${#array[@]} ]}

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
