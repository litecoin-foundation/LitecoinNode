#!/bin/bash

#change working directory
cd $HOME

#remove website files
echo "Removing node status page website files"
rm -r -f -v $DEBIAN_WEBSITE_DIR/banner.png
rm -r -f -v $DEBIAN_WEBSITE_DIR/bootstrap.css
rm -r -f -v $DEBIAN_WEBSITE_DIR/favicon.ico
rm -r -f -v $DEBIAN_WEBSITE_DIR/style.css

#remove the nginx webserver
read -r -p "Do you want to remove the nginx webserver and all of its components? (Y/N) " ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
	apt-get purge nginx nginx-common -y
	apt-get autoremove -y
	#disable firewall rule
	sudo ufw delete allow 80/tcp
fi

