#!/bin/bash
###############################################################################
## Upgrades Knox
## Tu 1 Nov 2016
###############################################################################

export GATEWAY_HOME=/usr/hdp/current/knox-server

if [[ 1 -ne ${#} ]];then
    echo "[ERROR] One argument required - the gateway version"
    exit 0    
fi
KNOX_VERSION=${1}

if [[ "root" != "${USER}" ]];then
    echo "[ERROR] Must be run as root"
    exit 0
fi

# Prepare the file system and Hadoop
mkdir -p /usr/hdp/${KNOX_VERSION}
hdp-select knox-server ${KNOX_VERSION}
cp /home/${SUDO_USER}/knox-${KNOX_VERSION}.tar.gz /usr/hdp/${KNOX_VERSION}`
cd /usr/hdp/${KNOX_VERSION}
tar xvzf knox-${KNOX_VERSION}.tar.gz
mv knox-${KNOX_VERSION} knox-server
chmod -R 755 knox-server
chown -R knox:knox knox-server

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
shopt -s nocasematch

