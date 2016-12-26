#!/bin/bash

#change working directory
cd $HOME

#add a user account for litecoind
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
echo "maxconnections=$CON_TOTAL" >> $LITECOIND_CONF_FILE
echo "addnode=$selectedarray_one" >> $LITECOIND_CONF_FILE
echo "addnode=$selectedarray_two" >> $LITECOIND_CONF_FILE

#setup dependencies
echo "Installing dependencies required for building Litecoin"
sudo apt-get install autoconf libtool libssl-dev libboost-all-dev libminiupnpc-dev -y
sudo apt-get install qt4-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev -y

#setup berkleydb and other build dependencies
echo "Setting up berkleydb"
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
tar -xzvf db-4.8.30.NC.tar.gz
cd db-4.8.30.NC/build_unix; ../dist/configure --enable-cxx
make -j2
sudo make install

#build litecoind
echo "Building Litecoin"
cd ..
git clone https://github.com/litecoin-project/litecoin.git
cd litecoin/
./autogen.sh
./configure CPPFLAGS="-I/usr/local/BerkeleyDB.4.8/include -O2" LDFLAGS="-L/usr/local/BerkeleyDB.4.8/lib"
make -j2
sudo make install

#Move the already built litecoind binary
echo "Moving litecoind to $LITECOIND_BIN_DIR"
cp -f -v litecoind $LITECOIND_BIN_DIR
cp -f -v litecoin-cli $LITECOIND_BIN_DIR

#add litecoind to systemd so it starts on system boot
echo "Adding Litecoind systemd script to make it start on system boot"
wget --progress=bar:force $RASPBIAN_SYSTEMD_DL_URL -P $RASPBIAN_SYSTEMD_CONF_DIR
chmod -R 0644 $RASPBIAN_SYSTEMD_CONF_DIR/$RASPBIAN_SYSTEMD_CONF_FILE
chown -R root:root $RASPBIAN_SYSTEMD_CONF_DIR/$RASPBIAN_SYSTEMD_CONF_FILE
systemctl enable litecoind.service #enable litecoind systemd config file

#do we want to predownload bootstrap.dat
read -r -p "Do you want to download the bootstrap.dat file? If you choose yes your initial blockhain sync will most likely be faster but will take up some extra space on your hard drive (Y/N) " ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
	echo "Downloading bootstrap.dat, this can take a moment"
	wget --progress=bar:force $BOOTSTRAP_DL_LOCATION -P $HOME/.litecoin
fi

#start litecoin daemon
echo "Starting litecoind"
systemctl start litecoind.service
