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
echo"Removing the litecoind upstart script."
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
iptables -D INPUT -p tcp --syn --dport 9333 -m connlimit --connlimit-above 8 --connlimit-mask 24 -j REJECT --reject-with tcp-reset
iptables -D INPUT -p tcp --syn --dport 9333 -m connlimit --connlimit-above 2 -j REJECT --reject-with tcp-reset
iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport 9333 -j ACCEPT


###This is not done yet
