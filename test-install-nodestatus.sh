#!/bin/bash

cd $HOME

echo "Installing firewall configuration tool"
apt-get update -y
apt-get install ufw -y

echo "Setting up firewall ports and enable firewall"
ufw allow ssh
ufw allow 80/tcp
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

echo "Add Litecoin rpc user and password to the nodestatus.py script"
sed -i -e '10iget_lcd_info = AuthServiceProxy("http://'"$RPC_USER"':'"$RPC_PASSWORD"'@127.0.0.1:9332")\' $HOME/scripts/nodestatus.py #add the generated rpcuser and rpcpassword to the nodestatus.py script
