#!/bin/bash
###############################################################################
## Upgrades Knox
## Tu 1 Nov 2016
###############################################################################

export GATEWAY_HOME=/usr/hdp/current/knox-server

# Ensure we get the version
if [[ 1 -ne ${#} ]];then
    echo "[ERROR] One argument required - the gateway version"
    exit 0    
fi
KNOX_VERSION=${1}

# Check who is running this
if [[ "root" != "${USER}" ]];then
    echo "[ERROR] Must be run as root"
    exit 0
fi

# Remove old directory if needed
if [[ -d /usr/hdp/${KNOX_VERSION} ]];then
    shopt -s nocasematch
    echo -n "Going to remove /usr/hdp/${KNOX_VERSION} - is this OK? [y/n]: "
    read REMOVE_IT
    if [[ "y" == "${REMOVE_IT}" ]];then
        rm -fr /usr/hdp/${KNOX_VERSION}
    fi
    shopt -u nocasematch
fi

# Prepare the file system
mkdir -p /usr/hdp/${KNOX_VERSION}
cp /home/${SUDO_USER}/knox-${KNOX_VERSION}.tar.gz /usr/hdp/${KNOX_VERSION}
cd /usr/hdp/${KNOX_VERSION}
tar xvzf knox-${KNOX_VERSION}.tar.gz
mv knox-${KNOX_VERSION} knox
chmod -R 755 knox
chown -R knox:knox knox

# Tell Hadoop what version we're using
hdp-select set knox-server ${KNOX_VERSION}

# Check the version
echo "[INFO] Check this is the version you expect"
ls -ltra /usr/hdp/current/knox-server

shopt -s nocasematch
echo -n "Is the right version linked to? [y/n]: "
read CORRECT_VERSION
if [[ "n" == "${CORRECT_VERSION}" ]];then
   shopt -s nocasematch 
   echo "[ERROR] Not the correct version"
   exit 0
fi
shopt -u nocasematch

