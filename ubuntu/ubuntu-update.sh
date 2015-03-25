#!/bin/bash

#change working directory
cd $HOME

#stop the litecoin daemon
echo "Stop Litecoind to make sure it does not lock any files"
stop litecoind

#remove old litecoind binary
echo "Removing old litecoind bin file"
rm -f -v $LITECOIND_BIN_DIR/litecoind

#download, unpack and move the new litecoind binary
echo "Downloading, unpacking and moving new Litecoind version to $LITECOIND_BIN_DIR"
wget $LITECOIN_DL_URL -P $HOME
tar xvfJ $HOME/$LITECOIN_VER.tar.xz
rm -f -v $HOME/$LITECOIN_VER.tar.xz
ARCH=$(getconf LONG_BIT)
cp -f -v $HOME/$LITECOIN_VER/bin/$ARCH/litecoind $LITECOIND_BIN_DIR
rm -r -f -v $HOME/$LITECOIN_VER

#start litecoin daemon
echo "Starting new litecoind"
start litecoind
