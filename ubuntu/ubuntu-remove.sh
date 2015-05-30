#!/bin/bash

#load global variables file
wget -q http://orange.litecoinnode.org/tests/glob-vars.sh -P /root
source /root/glob-vars.sh
rm -f -v /root/glob-vars.sh

#change working directory
cd $HOME

#do we want to remove litecoin
read -r -p "Do you want to remove Litecoin? (Y/N) " ANSWER
echo
if [[ $ANSWER =~ ^([yY])$ ]]
then
	wget $UBUNTU_BASE/$DIST-remove-litecoin.sh -P $HOME
	source $HOME/$DIST-remove-litecoin.sh
	rm -f -v $HOME/$DIST-remove-litecoin.sh
fi

#do we want to remove the http status page
#read -r -p "Do you want to remove the http status page? (Y/N) " ANSWER
#echo
#if [[ $ANSWER =~ ^([yY])$ ]]
#then
#	wget $UBUNTU_BASE/$DIST-remove-statuspage.sh -P $HOME
#	source $HOME/$DIST-remove-statuspage.sh
#	rm -f -v $HOME/$DIST-remove-statuspage.sh
#fi
