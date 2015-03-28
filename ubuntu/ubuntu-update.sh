#!/bin/bash

#change working directory
cd $HOME

#define directory locations
WEBSITE_DIR="/usr/share/nginx/html" #the directory that stores the http status page files

#check version
LOC_VERSION=$(sed -n 1p $HOME/scripts/version) #get the current local version number
REP_VERSION=$(sed -n 1p $SCRIPT_DL_URL/shared/version) #get the current version number from the repository

if [ "$LOC_VERSION" -lt "$REP_VERSION" ]
then
	#stop the litecoin daemon
	echo "Stop Litecoind to make sure it does not lock any files"
	stop litecoind

	#remove old litecoind binary
	echo "Removing old litecoind bin file"
	rm -f -v $LITECOIND_BIN_DIR/litecoind

	#download, unpack and move the new litecoind binary
	echo "Downloading, unpacking and moving new Litecoind version to $LITECOIND_BIN_DIR"
	wget $LITECOIN_DL_URL -P $HOME
	tar xvfJ $HOME/$LITECOIN_VER.tar.xz
	rm -f -v $HOME/$LITECOIN_VER.tar.xz
	ARCH=$(getconf LONG_BIT)
	cp -f -v $HOME/$LITECOIN_VER/bin/$ARCH/litecoind $LITECOIND_BIN_DIR
	rm -r -f -v $HOME/$LITECOIN_VER

	#start litecoin daemon
	echo "Starting new litecoind"
	start litecoind

	#remove current and download the new version file
	echo "Removing current version file."
	rm -f -v $HOME/scripts/version
	echo "Downloading the new version file."
	wget $SCRIPT_DL_URL/shared/version -P $HOME/scripts
	chmod -R 0600 $HOME/scripts/version
	chown -R root:root $HOME/scripts/version
	
	#update the node status page and litecoin-node-status.py script if the litecoin-node-status.py file exists
	NODESTATUS_FILE="$HOME/scripts/litecoin-node-status.py"
	if [ -f "$NODESTATUS_FILE" ]
	then

		#remove current website files
		echo "removing current website files"
		rm -f -v $WEBSITE_DL_URL/banner.png
		rm -f -v $WEBSITE_DL_URL/bootstrap.css
		rm -f -v $WEBSITE_DL_URL/favicon.ico
		rm -f -v $WEBSITE_DL_URL/style.css

		#get update the website files
		echo "Updating current website files"
		wget $WEBSITE_DL_URL/banner.png -P $WEBSITE_DIR
		wget $WEBSITE_DL_URL/bootstrap.css -P $WEBSITE_DIR
		wget $WEBSITE_DL_URL/favicon.ico -P $WEBSITE_DIR
		wget $WEBSITE_DL_URL/style.css -P $WEBSITE_DIR

		#Remove the current litecoin-node-status.py file
		echo "Remove litecoin-node-status.py file"
		rm -f -v $HOME/scripts/litecoin-node-status.py

		#get updated litecoin-node-status.py file
		echo "download new litecoin-node-status.py file"
		wget $NODESTATUS_DL_URL -P $HOME/scripts
		chmod -R 0700 $HOME/scripts/litecoin-node-status.py
		chown -R root:root $HOME/scripts/litecoin-node-status.py

		#get the rpcuser and rpcuserpassword from the litecoin.conf file to inject later
		RPC_USER=$(sed -n 1p $LITECOIND_CONF_FILE | cut -c9-39) #get the rpcuser  from the litecoin.conf file
		RPC_PASSWORD=$(sed -n 2p $LITECOIND_CONF_FILE | cut -c13-42) #get the rpcuserpassword from the litecoin.conf file

		#Add $WEBSITE_DIR to the new litecoin-node-status.py script
		echo "Add the distributions website dir to the litecoin-nodes-status.py script"
		sed -i -e '13iff = open('"'$WEBSITE_DIR/index.html'"', '"'w'"')\' $HOME/scripts/litecoin-node-status.py

		#Add Litecoin rpc user and password to the  new litecoin-node-status.py script
		echo "Add Litecoin rpc user and password to the litecoin-nodes-tatus.py script"
		sed -i -e '10iget_lcd_info = AuthServiceProxy("http://'"$RPC_USER"':'"$RPC_PASSWORD"'@127.0.0.1:9332")\' $HOME/scripts/litecoin-node-status.py #add the rpcuser and rpcpassword to the litecoin-node-status.py script
else
	echo "No need to update, exiting."
fi
