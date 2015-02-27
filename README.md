# DeploymentScripts

The deployment scripts code repository is a small open source project of [litecoinnode.org](http://litecoinnode.org)

The project was inspired by a post on the [LitecoinTalk](https://litecointalk.org/index.php?topic=24338.0) forums by Losh11 and aims to make it easy for individuals to deploy and maintain Litecoin full nodes.

The scripts are currently in development, use at your own risk! For more information about the project visit [litecoinnode.org](http://litecoinnode.org)

## Features

- Installation and configuration of litecoind
- A html page that displays the status of your node 

## Requirements

- A Linux server
- Some experience with the Linux operating system
- Plenty of upstream bandwidth
- Some spare CPU cycles

NOTE: This script might work on other distributions but is currently only tested on Ubuntu 14.04 LTS. If you tested it successfully on other systems please let us know!

## Installation

Log in to your Linux server and elevate to root.

```bash
$sudo su root
```

Run the deployment script.

```bash
$wget https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/master/ubuntu-setup.sh -P /root/ ; bash /root/ubuntu-setup.sh 2>&1 | tee /root/nodesetup.log
```

The installation will start and leave a log file of the installation at /root/nodesetuplog.log for you to review.

## Word of warning

Please do not run scripts from the internet without reviewing them first! Always know what you are getting into before executing anything untrusted from the internet.

This script will reboot your server when it is done! For your convenience it will wait one minute before is issues the restart command so you have time to abort if you do not want to reboot your server after the script is done. You can abort with the key combination CRTL+C.

Please test before deploying to production! Testing takes a bit of time but never hurts in the long run!
