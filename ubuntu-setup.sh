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

#change working directory
cd /root

echo "Performing initial system updates"
apt-get update -y
apt-get upgrade -y

echo "Installing firewall configuration tool"
apt-get install ufw -y

echo "Setting up firewall ports and enable firewall"
ufw allow ssh
ufw allow 80/tcp
ufw allow 9333/tcp
iptables -A INPUT -p tcp --syn --dport 9333 -m connlimit --connlimit-above 8 --connlimit-mask 24 -j REJECT --reject-with tcp-reset
iptables -A INPUT -p tcp --syn --dport 9333 -m connlimit --connlimit-above 2 -j REJECT --reject-with tcp-reset
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 9333 -j ACCEPT
ufw --force enable

echo "Installing the nginx webserver and downloading needed files to display the node status page"
apt-get install nginx -y
rm -r -f -v $WEBSITE_DIR/*
touch $WEBSITE_DIR/index.html

#downloading needed files to display the node status page
wget $WEBSITE_DL_URL/banner.png -P $WEBSITE_DIR
wget $WEBSITE_DL_URL/bootstrap.css -P $WEBSITE_DIR
wget $WEBSITE_DL_URL/favicon.ico -P $WEBSITE_DIR
wget $WEBSITE_DL_URL/style.css -P $WEBSITE_DIR

echo "Install python dependencies and download, save and set permissions for node status script"
apt-get install python-pip -y
pip install python-bitcoinrpc
wget $NODESTATUS_DL_URL -P $HOME/scripts
chmod -R 0700 $HOME/scripts/nodestatus.py
chown -R root:root $HOME/scripts/nodestatus.py

echo "Add the node status script to cron and run it every 10 minutes"
echo "*/10 * * * * /usr/bin/python $HOME/scripts/nodestatus.py" >> /$HOME/scripts/crontempfile
crontab $HOME/scripts/crontempfile
rm $HOME/scripts/crontempfile

echo "Adding unprivileged user account for litecoind, building the needed folder structure and setting folder permissions"
useradd -s /usr/sbin/nologin $LITECOIND_USER 

#create home directory
mkdir -v -p $LITECOIND_HOME_DIR
chmod -R 0755 $LITECOIND_HOME_DIR
chown -R $LITECOIND_USER:$LITECOIND_GROUP $LITECOIND_HOME_DIR
#create data directory
mkdir -v -p $LITECOIND_DATA_DIR
chmod -R 0700 $LITECOIND_DATA_DIR
chown -R $LITECOIND_USER:$LITECOIND_GROUP $LITECOIND_DATA_DIR
#create conf file
touch $LITECOIND_CONF_FILE
chmod -R 0600 $LITECOIND_CONF_FILE
chown -R $LITECOIND_USER:$LITECOIND_GROUP $LITECOIND_CONF_FILE
#create bin directory
mkdir -v -p $LITECOIND_BIN_DIR
chmod -R 0700 $LITECOIND_BIN_DIR
chown -R $LITECOIND_USER:$LITECOIND_GROUP $LITECOIND_BIN_DIR

echo "Creating the litecoin.conf file"
RPC_USER=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30` #this generates a random rpc username
RPC_PASSWORD=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30` #this generates a random rpc password
echo "rpcuser=$RPC_USER" >> $LITECOIND_CONF_FILE
echo "rpcpassword=$RPC_PASSWORD" >> $LITECOIND_CONF_FILE
echo "rpcallowip=127.0.0.1" >> $LITECOIND_CONF_FILE
echo "server=1" >> $LITECOIND_CONF_FILE
echo "daemon=1" >> $LITECOIND_CONF_FILE
echo "disablewallet=1" >> $LITECOIND_CONF_FILE
echo "maxconnections=125" >> $LITECOIND_CONF_FILE
echo "addnode=ltc.lurkmore.com" >> $LITECOIND_CONF_FILE
sed -i -e '10iget_lcd_info = AuthServiceProxy("http://'"$RPC_USER"':'"$RPC_PASSWORD"'@127.0.0.1:9332")\' $HOME/scripts/nodestatus.py #add the generated rpcuser and rpcpassword to the nodestatus.py script

echo "Downloading, unpacking and moving Litecoind to $LITECOIND_BIN_DIR"
wget $LITECOIN_DL_URL -P $HOME
tar xvfJ $HOME/$LITECOIN_VER.tar.xz
rm -f -v $HOME/$LITECOIN_VER.tar.xz
ARCH=$(getconf LONG_BIT)
cp -f -v $HOME/$LITECOIN_VER/bin/$ARCH/litecoind $LITECOIND_BIN_DIR
rm -r -f -v $HOME/$LITECOIN_VER

echo "Detect if a swap file exists and create one if this is not the case" #this needs more testing
TOTAL_RAM=`awk '/MemTotal/{print $2}' /proc/meminfo` #get current system memory to base swap size on
if free | awk '/^Swap:/ {exit !$2}'; then
    echo "Skip creation of swap it already exists!"
else
    dd if=/dev/zero of=/swapfile bs=1M count=$TOTAL_RAM ; mkswap /swapfile ; swapon /swapfile
	echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
	echo "Created swapfile!"
fi

echo "Adding Litecoind upstart script to make it start on system boot"
wget $UPSTART_DL_URL -P $UPSTART_CONF_DIR
chmod -R 0644 $UPSTART_CONF_DIR/$UPSTART_CONF_FILE
chown -R root:root $UPSTART_CONF_DIR/$UPSTART_CONF_FILE
initctl reload-configuration #reload the init config

echo "All done! rebooting system"
shutdown -r 1 Press CTRL+C to abort.
