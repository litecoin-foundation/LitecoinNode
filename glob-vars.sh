#define user account, group and current litecoin version 
LITECOIND_USER="litecoin" #the user litecoind will run under
LITECOIND_GROUP="litecoin" #the group litecoind is a member of
LITECOIN_VER="litecoin-0.8.7.5-linux" #current litecoin version

#define directory locations
HOME="/root" #home directory of the root user, we store some script and tempfiles here
LITECOIND_BIN_DIR="/home/litecoind/bin" #the directory that stores the binary file of litecoind
LITECOIND_DATA_DIR="/home/litecoind/.litecoin" #the directory that holds the litecoind data
LITECOIND_HOME_DIR="/home/litecoind" #home directory of litecoin user account

#define configuration file locations
LITECOIND_CONF_FILE="/home/litecoind/.litecoin/litecoin.conf" #the litecoind configuration file

#define test download locations. do not uncomment this unless you know what you are doing!
SCRIPT_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/testing" #the test download location of the script files
WEBSITE_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/testing/shared/www" #the test download location of the status page website files

#generate random user and password for rpc
RPC_USER=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30` #this generates a random rpc username
RPC_PASSWORD=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30` #this generates a random rpc password

#define download locations
#SCRIPT_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/master" #the download location of the script files
#WEBSITE_DL_URL="https://raw.githubusercontent.com/LitecoinNode/DeploymentScripts/master/shared/www" #the download location of the status page website files
LITECOIN_DL_URL="https://download.litecoin.org/litecoin-0.8.7.5/linux/litecoin-0.8.7.5-linux.tar.xz" #litecoin download link
NODESTATUS_DL_URL="$SCRIPT_DL_URL/shared/litecoin-node-status.py" #the download location of the nodestatus.py file

#ubuntu specific variables
#define ubuntu directory locations
UBUNTU_UPSTART_CONF_DIR="/etc/init" #the directory that holds the litecoind upstart configuration file
UBUNTU_WEBSITE_DIR="/usr/share/nginx/html" #the directory that stores the http status page files

#define configuration file locations
UBUNTU_UPSTART_CONF_FILE="litecoind.conf" #name of the litecoind upstart script config file. This is not the litecoin.conf file!

#define download locations
UBUNTU_BASE="$SCRIPT_DL_URL/$DIST" #base directory for ubuntu script files
UBUNTU_UPSTART_DL_URL="$UBUNTU_BASE/litecoind.conf" #the download location of the upstart.conf file for litecoind
