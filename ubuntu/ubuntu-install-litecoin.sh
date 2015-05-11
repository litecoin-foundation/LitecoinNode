#!/bin/bash

#change working directory
cd $HOME

#add user account for litecoind
echo "Adding unprivileged user account for litecoind, building the needed folder structure and setting folder permissions"
useradd -s /usr/sbin/nologin $LITECOIND_USER

#install ufw firewall configuration package
echo "Installing firewall configuration tool"
apt-get install ufw -y

#allow needed firewall ports
echo "Setting up firewall ports and enable firewall"
ufw allow ssh
ufw allow 9333/tcp
iptables -A INPUT -p tcp --syn --dport 9333 -m connlimit --connlimit-above 8 --connlimit-mask 24 -j REJECT --reject-with tcp-reset
iptables -A INPUT -p tcp --syn --dport 9333 -m connlimit --connlimit-above 2 -j REJECT --reject-with tcp-reset
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 9333 -j ACCEPT
ufw --force enable

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

#create litecoin.conf file
echo "Creating the litecoin.conf file"
echo "rpcuser=$RPC_USER" >> $LITECOIND_CONF_FILE
echo "rpcpassword=$RPC_PASSWORD" >> $LITECOIND_CONF_FILE
echo "rpcallowip=127.0.0.1" >> $LITECOIND_CONF_FILE
echo "server=1" >> $LITECOIND_CONF_FILE
echo "daemon=1" >> $LITECOIND_CONF_FILE
echo "disablewallet=1" >> $LITECOIND_CONF_FILE
echo "maxconnections=125" >> $LITECOIND_CONF_FILE
echo "addnode=ltc.lurkmore.com" >> $LITECOIND_CONF_FILE

#gets arch data
then
    LITECOIN_DL_URL=$LITECOIN_DL_URL_64
    LITECOIN_VER="litecoin-0.10.1.3-linux64"
else
    LITECOIN_DL_URL=$LITECOIN_DL_URL_32
    LITECOIN_VER="litecoin-0.10.1.3-linux32"
fi

#download, unpack and move the litecoind binary
echo "Downloading, unpacking and moving litecoind to $LITECOIND_BIN_DIR"
wget $LITECOIN_DL_URL -P $HOME
tar -zxvf $HOME/$LITECOIN_VER.tar.gz
rm -f -v $HOME/$LITECOIN_VER.tar.gz
cp -f -v $HOME/$LITECOIN_VER/bin/litecoind $LITECOIND_BIN_DIR
cp -f -v $HOME/$LITECOIN_VER/bin/litecoin-cli $LITECOIND_BIN_DIR
rm -r -f -v $HOME/$LITECOIN_VER

#add litecoind to upstart so it starts on system boot
echo "Adding Litecoind upstart script to make it start on system boot"
wget $UPSTART_DL_URL -P $UPSTART_CONF_DIR
chmod -R 0644 $UPSTART_CONF_DIR/$UPSTART_CONF_FILE
chown -R root:root $UPSTART_CONF_DIR/$UPSTART_CONF_FILE
initctl reload-configuration #reload the init config

#start litecoin daemon
echo "Starting litecoind"
start litecoind
