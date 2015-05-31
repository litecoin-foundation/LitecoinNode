#!/bin/bash

#stop the litecoin daemon
echo "Stop Litecoind to make sure it does not lock any files"
stop litecoind

#remove the upstart script
echo "Removing the litecoind upstart script"
rm -r -f -v $UBUNTU_UPSTART_CONF_DIR/$UBUNTU_UPSTART_CONF_FILE
initctl reload-configuration #reload the init config

#remove the litecoind user account and group
echo "Removing the litecoind user and group"
userdel $LITECOIND_USER
groupdel $LITECOIND_GROUP

#check if the litecoin-node-status.py script exists and remove it if true
NODESTATUS_FILE="$HOME/scripts/litecoin-node-status.py"

if [ -f "$NODESTATUS_FILE" ]
then
	#Remove the litecoin-node-status.py file
	echo "Removing the litecoin node status file"
	rm -f -v $NODESTATUS_FILE

	#remove litecoin-node-status.py from cron
	echo "Removing litecoin node status script from cron"
	crontab -l > $HOME/scripts/crontempfile
	sed -i '/litecoin-node-status.py/d' $HOME/scripts/crontempfile
	crontab $HOME/scripts/crontempfile
	rm $HOME/scripts/crontempfile
	pip uninstall python-bitcoinrpc -y #remove python-bitcoinrpc as it is no longer useful without litecoind running
fi

#check if the ubuntu-update.sh script exists and remove it if true
UBUNTU_UPDATE_FILE="$HOME/scripts/ubuntu-update.sh"

if [ -f "$UBUNTU_UPDATE_FILE" ]
then

	#Remove the ubuntu-update.sh file
	echo "Removing the ubuntu update file"
	rm -f -v $UBUNTU_UPDATE_FILE

	#remove ubuntu-update.sh from cron
	echo "Removing the update script from cron"
	crontab -l > $HOME/scripts/crontempfile
	sed -i '/ubuntu-update.sh/d' $HOME/scripts/crontempfile
	crontab $HOME/scripts/crontempfile
	rm $HOME/scripts/crontempfile
fi

#Below we check if the wallet.dat file exists in /home/litecoind/.litecoin. The project specifically lets litecoind run with the --disable wallet option so a wallet.dat
#should not exist in /home/litecoind/.litecoin but if it does for whatever reason we should back it up just in case

#check if the wallet file exists and back it up if true
WALLET_FILE="$HOME/.litecoin/wallet.dat"

if [ -f "$WALLET_FILE" ]
then
        #backup the wallet file
        echo "Backing up the wallet.dat file to /root/backup/litecoind"
        mkdir -p /root/backup/litecoind
        mv -v $WALLET_FILE /root/backup/litecoind/wallet.dat
fi

#remove litecoin specific firewall rules
echo "Removing firewall rules."
sudo ufw delete allow 9333/tcp
iptables -D INPUT -p tcp --syn --dport 9333 -m connlimit --connlimit-above 8 --connlimit-mask 24 -j REJECT --reject-with tcp-reset
iptables -D INPUT -p tcp --syn --dport 9333 -m connlimit --connlimit-above 2 -j REJECT --reject-with tcp-reset
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport 9333 -j ACCEPT

#remove litecoind home directory
echo "Removing the litecoind home directory."
rm -r -f -v $LITECOIND_HOME_DIR
