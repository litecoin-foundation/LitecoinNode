#!/bin/bash

#load global variables file
wget -q http://orange.litecoinnode.org/tests/glob-vars.sh -P /root
source /root/glob-vars.sh
rm -f -v /root/glob-vars.sh

#change working directory
cd $HOME

#stop the litecoin daemon
echo "Stop Litecoind to make sure it does not lock any files"
stop litecoind

#remove the upstart script
echo"Removing the litecoind updtard script."
rm -r -f -v $UBUNTU_UPSTART_CONF_FILE
initctl reload-configuration #reload the init config

#remove the litecoind user account and group
echo "Removing the litecoind user and group"
userdel $LITECOIND_USER
groupdel $LITECOIND_GROUP

#remove litecoind home directory
echo "removing the litecoind home directory."
rm -r -f -v $LITECOIND_HOME_DIR

#setup firewall rules
echo "Removing firewall rules."
sudo ufw delete allow 9333/tcp
