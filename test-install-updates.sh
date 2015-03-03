#!/bin/bash

cd $HOME

echo "Performing initial system updates"
apt-get update -y
apt-get upgrade -y
