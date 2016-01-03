#!/bin/bash

#change working directory
cd $HOME

#install ufw firewall configuration package
echo "Installing firewall configuration tool"
apt-get install ufw -y

#allow needed firewall ports
echo "Setting up firewall ports and enable firewall"
ufw allow ssh
ufw allow 80/tcp
ufw --force enable

#install nginx webserver to display http status page
echo "Installing the nginx webserver and downloading needed files to display the node status page"
apt-get install nginx -y
rm -r -f -v $UBUNTU_WEBSITE_DIR/*
touch $UBUNTU_WEBSITE_DIR/index.html

#downloading needed files to display the http status page
wget $WEBSITE_DL_URL/banner.png -P $UBUNTU_WEBSITE_DIR
wget $WEBSITE_DL_URL/bootstrap.css -P $UBUNTU_WEBSITE_DIR
wget $WEBSITE_DL_URL/favicon.ico -P $UBUNTU_WEBSITE_DIR
wget $WEBSITE_DL_URL/style.css -P $UBUNTU_WEBSITE_DIR

#install python dependencies for node status python script
echo "Install python dependencies and download, save and set permissions for node status script"
apt-get install python-pip -y
pip install python-bitcoinrpc==0.1
wget $NODESTATUS_DL_URL -P $HOME/scripts
chmod -R 0700 $HOME/scripts/litecoin-node-status.py
chown -R root:root $HOME/scripts/litecoin-node-status.py

#add the python node status script to cron and run it every 10 minutes
echo "Add the node status script to cron and run it every 10 minutes"
crontab -l > $HOME/scripts/crontempfile
echo "*/10 * * * * /usr/bin/python $HOME/scripts/litecoin-node-status.py" >> /$HOME/scripts/crontempfile
crontab $HOME/scripts/crontempfile
rm $HOME/scripts/crontempfile

#Add $UBUNTU_WEBSITE_DIR to the litecoin-node-status.py script
echo "Add the distributions website dir to the litecoin-nodes-status.py script"
sed -i -e '13iff = open('"'$UBUNTU_WEBSITE_DIR/index.html'"', '"'w'"')\' $HOME/scripts/litecoin-node-status.py

#Add Litecoin rpc user and password to the litecoin-node-status.py script
echo "Add Litecoin rpc user and password to the litecoin-nodes-tatus.py script"
sed -i -e '10iget_lcd_info = AuthServiceProxy("http://'"$RPC_USER"':'"$RPC_PASSWORD"'@127.0.0.1:9332")\' $HOME/scripts/litecoin-node-status.py #add the generated rpcuser and rpcpassword to the litecoin-node-status.py script
python $HOME/scripts/litecoin-node-status.py
