# LitecoinNode

## What is LitecoinNode?

This project is an attempt to make it simpler for anyone who wishes to install the software to ‘become’ a supernode. In other words, the LitecoinNode script allows everyone/anyone to simply answer a bunch of questions; leading to your computer running a full Litecoin Supernode. Here are some features that LitecoinNode supports:-

- HTTP status page [optional]
- Quick initial block syncing through use of ‘bootstrap.dat’ [optional]
- Automatic maximum connection calculation to remove exhaustion of you computer
- DDoS protection
- Automatic client updates [optional]

## Why run a Supernode?

A supernode is just a computer which runs the Litecoin Core client 24/7. It allows for long term storage of transactions (through the blockchain). This is done by: syncing the relevant block (group of transactions) with other Litecoin Clients which may not used all day. If you are familiar with Bitcoin, then a supernode is the equivalent of a Bitcoin full node. This list include many of the uses of a supernode:- 

- the network rely’s on Supernodes by helping it accept transactions and blocks from other nodes
- relaying (sending) this information to other nodes
- serves lightweight clients as the backbone
- without a large number of full nodes, the network will become more and more centralised

## Requirements

- Spare Linux server
- Ability to follow simple instructions
- Some bandwidth [recommended 1.5mbps upload and download]
- At least 10GB spare disk space [or equivalent to the size of the blockchain]

## Installation

- Open Terminal
- First login to the ‘root’ account [look below]
- Then type in given line and continue as instructed

```
sudo su root
```
```
wget https://raw.githubusercontent.com/litecoin-association/LitecoinNode/master/linux.sh -P /root/ ; bash /root/linux.sh 2>&1 | tee /root/install.log
```

## Updating

Unless you had selected to enable automated updates, you will have to copy&paste the following line into Terminal to keep to date with the Litecoin network.

```
sudo su root
```
```
wget https://raw.githubusercontent.com/litecoin-association/LitecoinNode/master/linux.sh -P /root/ ; bash /root/linux.sh 2>&1 | tee /root/update.log
```

## Word of warning

Please do not run scripts from the internet without reviewing them first! Always know what you are getting into before executing anything untrusted from the internet. This script will reboot your server when it is done! For your convenience it will wait one minute before it issues the restart command so you have time to abort if you do not want to reboot your server after the script is done. You can abort with the key combination CTRL+C.

## Any errors?

Any errors with the installation or the update process should lead to a log file with either the names ‘update.log’ or ‘install.log’ - if there is something wrong, please visit our [GitHub] (https://github.com/litecoin-association/LitecoinNode) and create an issue attached with the corresponding log file. Don’t hesitate to report any errors you encounter.
