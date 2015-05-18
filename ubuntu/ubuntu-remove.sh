#!/bin/bash

#load global variables file
wget -q http://orange.litecoinnode.org/tests/glob-vars.sh -P /root
source /root/glob-vars.sh
rm -f -v /root/glob-vars.sh

#change working directory
cd $HOME
