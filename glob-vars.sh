#define user account, group and current litecoin version
LITECOIND_USER="litecoind" #the user litecoind will run under
LITECOIND_GROUP="litecoind" #the group litecoind is a member of
#LITECOIN_VER="litecoin-0.8.7.5-linux" #current litecoin version
LITECOIN_VER_NO_BIT="litecoin-0.10.1.3"

#define directory locations
HOME="/home/litecoind" #home directory of the litecoind user, we store some script and tempfiles here
LITECOIND_BIN_DIR="$HOME/bin" #the directory that stores the binary file of litecoind
LITECOIND_DATA_DIR="$HOME/.litecoin" #the directory that holds the litecoind data
LITECOIND_HOME_DIR="$HOME" #home directory of litecoin user account

#define configuration file locations
LITECOIND_CONF_FILE="$HOME/.litecoin/litecoin.conf" #the litecoind configuration file

#define test download locations. do not uncomment this unless you know what you are doing!
SCRIPT_DL_URL="https://raw.githubusercontent.com/litecoin-association/LitecoinNode/testing" #the test download location of the script files
WEBSITE_DL_URL="https://raw.githubusercontent.com/litecoin-association/LitecoinNode/testing/shared/www" #the test download location of the status page website files

#generate random user and password for rpc
RPC_USER=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30` #this generates a random rpc username
RPC_PASSWORD=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30` #this generates a random rpc password

#calculate the max connections to insert into litecoin.conf based on memory
#this calculation might need some fine-tuning. It currently uses total system memory in kb divides it by 1024 and then divides it by 8 to get a rough estimate of connection count and then rounds the number
#added conversion from float to int - you can't have decimal peers
#verify this still works
CON_TOTAL=$(grep MemTotal: /proc/meminfo | awk '($2) {CON_TOTAL=($2/1024/8)+0.5/1} END{printf "%0.f\n", CON_TOTAL}')

#define arch for download
ARCH=$(getconf LONG_BIT)

#array for random sync node to insert in litecoin.conf
array=("ltc.1001bitcoins.com" "supernode-02.hashfaster.com" "ltc.block-explorer.com" "192.241.134.130" "198.27.97.187" "ltc.9mmo.com" "ltcsupernode.cafecode.com" "ltc.commy.org" "p2pool.cryptogeeks.com" "195.154.14.72" "cryptochart.com" "37.139.3.160" "super.sw.gy" "supernode-03.hashfaster.com" "litecointools.com" "72.26.202.244" "192.241.166.112" "supernode-2.give-me-coins.com" "lites.pw" "37.187.3.125" "ltc.lurkmore.com" "pool.ltc4u.net" "46.105.96.190" "ltc.lfcvps.com" "supernode-01.hashfaster.com" "supernode-ltc.litetree.com" "54.234.44.180" "ottrbutt.com" "95.85.28.149" "54.204.67.137" "ltc.serversresort.com" "162.243.254.90" "195.154.12.243" "supernode-3.give-me-coins.com" "192.241.193.227" "109.201.133.197" "198.199.103.138")
RANDOM=$$$(date +%s)
selectedarray_one=${array[$RANDOM % ${#array[@]} ]}
selectedarray_two=${array[$RANDOM % ${#array[@]} ]}

#define download locations
#SCRIPT_DL_URL="https://raw.githubusercontent.com/litecoin-association/LitecoinNode/master" #the download location of the script files
#WEBSITE_DL_URL="https://raw.githubusercontent.com/litecoin-association/LitecoinNode/master/shared/www" #the download location of the status page website files
LITECOIN_DL_URL_64="https://download.litecoin.org/test/litecoin/v0.10.1.3/linux/litecoin-0.10.1.3-linux64.tar.gz" #litecoin x64 download link
LITECOIN_DL_URL_32="https://download.litecoin.org/test/litecoin/v0.10.1.3/linux/litecoin-0.10.1.3-linux32.tar.gz" #litecoin x32 download link
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
