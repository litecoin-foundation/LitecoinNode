#!/bin/bash

#load global variables file
wget -q https://raw.githubusercontent.com/litecoin-association/LitecoinNode/master/glob-vars.sh -P /root
source /root/glob-vars.sh
rm -f -v /root/glob-vars.sh

#change working directory
cd $HOME

#get current version from repository
wget $SCRIPT_DL_URL/shared/version -P $HOME

#check version
LOC_VERSION=$(sed -n 1p $HOME/scripts/version) #get the current local version number
REP_VERSION=$(sed -n 1p $HOME/version) #get the current version number from the repository

if [ "$LOC_VERSION" -lt "$REP_VERSION" ]
then
	#stop the litecoin daemon
	echo "We need to update!"
	echo "Stop Litecoind to make sure it does not lock any files"
	stop litecoind

	#remove old litecoind binary
	echo "Removing old litecoind bin file"
	rm -f -v $LITECOIND_BIN_DIR/litecoind
	rm -f -v $LITECOIND_BIN_DIR/litecoin-cli

	#gets arch data
	if test $ARCH -eq "64"
	then
	LITECOIN_DL_URL=$LITECOIN_DL_URL_64
	LITECOIN_VER="litecoin-0.10.1.3-linux64"
	else
	LITECOIN_DL_URL=$LITECOIN_DL_URL_32
	LITECOIN_VER="litecoin-0.10.1.3-linux32"
	fi
	
	#download, unpack and move the new litecoind binary
	echo "Downloading, unpacking and moving new Litecoind version to $LITECOIND_BIN_DIR"
	wget $LITECOIN_DL_URL -P $HOME
	tar zxvf $HOME/$LITECOIN_VER.tar.gz
	rm -f -v $HOME/$LITECOIN_VER.tar.gz
	cp -f -v $HOME/$LITECOIN_VER_NO_BIT/bin/litecoind $LITECOIND_BIN_DIR
	cp -f -v $HOME/$LITECOIN_VER_NO_BIT/bin/litecoin-cli $LITECOIND_BIN_DIR
	rm -r -f -v $HOME/$LITECOIN_VER

	#start litecoin daemon
	echo "Starting new litecoind"
	start litecoind

	#remove current and move the new version file
	echo "Removing current version file."
	rm -f -v $HOME/scripts/version
	echo "Moving the new version file."
	mv -v $HOME/version $HOME/scripts
	chmod -R 0600 $HOME/scripts/version
	chown -R root:root $HOME/scripts/version
	
	#update the node status page and litecoin-node-status.py script if the litecoin-node-status.py file exists
	NODESTATUS_FILE="$HOME/scripts/litecoin-node-status.py"

	if [ -f "$NODESTATUS_FILE" ]
	then

		#remove current website files
		echo "removing current website files"
		rm -f -v $UBUNTU_WEBSITE_DIR/banner.png
		rm -f -v $UBUNTU_WEBSITE_DIR/bootstrap.css
		rm -f -v $UBUNTU_WEBSITE_DIR/favicon.ico
		rm -f -v $UBUNTU_WEBSITE_DIR/style.css

		#get update the website files
		echo "Updating current website files"
		wget $WEBSITE_DL_URL/banner.png -P $UBUNTU_WEBSITE_DIR
		wget $WEBSITE_DL_URL/bootstrap.css -P $UBUNTU_WEBSITE_DIR
		wget $WEBSITE_DL_URL/favicon.ico -P $UBUNTU_WEBSITE_DIR
		wget $WEBSITE_DL_URL/style.css -P $UBUNTU_WEBSITE_DIR

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

		#Add $UBUNTU_WEBSITE_DIR to the new litecoin-node-status.py script
		echo "Add the distributions website dir to the litecoin-nodes-status.py script"
		sed -i -e '13iff = open('"'$UBUNTU_WEBSITE_DIR/index.html'"', '"'w'"')\' $HOME/scripts/litecoin-node-status.py

		#Add Litecoin rpc user and password to the  new litecoin-node-status.py script
		echo "Add Litecoin rpc user and password to the litecoin-nodes-tatus.py script"
		sed -i -e '10iget_lcd_info = AuthServiceProxy("http://'"$RPC_USER"':'"$RPC_PASSWORD"'@127.0.0.1:9332")\' $HOME/scripts/litecoin-node-status.py #add the rpcuser and rpcpassword to the litecoin-node-status.py script
		
		#Add a countdown to give litecoind some time to start before updating the nodestatus page to prevent an access denied error
		echo "Start countdown to give litecoind some time to start before updating the node status page."
		cdtime=$((1 * 15))
		while [ $cdtime -gt 0 ]; do
			echo -ne "$cdtime\033[0K\r"
			sleep 1
			: $((cdtime--))
		done
		
		#update the nodestatus page
		python $HOME/scripts/litecoin-node-status.py
	fi
else
	rm -f -v $HOME/version
	echo "No need to update, exiting."
fi
