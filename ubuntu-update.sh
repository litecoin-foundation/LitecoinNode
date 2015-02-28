#!/bin/bash

#define directory locations
HOME="/root" #home directory of the root user, we store some script and tempfiles here
LITECOIND_BIN_DIR="/home/litecoind/bin" #the directory that stores the binary file of litecoind

#define litecoin version and download location
LITECOIN_VER="litecoin-0.8.7.5-linux"
LITECOIN_DL_URL="https://download.litecoin.org/litecoin-0.8.7.5/linux/litecoin-0.8.7.5-linux.tar.xz"

#change working directory
cd $HOME

echo "Stop Litecoind to make sure it does not lock any files"
stop litecoind

echo "Removing old litecoind bin file"
rm -f -v $LITECOIND_BIN_DIR/litecoind

echo "Downloading, unpacking and moving new Litecoind version to $LITECOIND_BIN_DIR"
wget $LITECOIN_DL_URL -P $HOME
tar xvfJ $HOME/$LITECOIN_VER.tar.xz
rm -f -v $HOME/$LITECOIN_VER.tar.xz
ARCH=$(getconf LONG_BIT)
cp -f -v $HOME/$LITECOIN_VER/bin/$ARCH/litecoind $LITECOIND_BIN_DIR
rm -r -f -v $HOME/$LITECOIN_VER

echo "Starting new litecoind"
start litecoind
