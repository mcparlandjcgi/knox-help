#!/bin/bash
###############################################################################
## Upgrade Knox
## John McParland
## F 28 Oct 2016
###############################################################################

if [[ 1 -ne ${#} ]];then
    echo "[ERROR] You need to specify the knox version being installed"
    exit 0
else
    KNOX_VERSION=${1}
fi

SCRIPT_USER=`whoami`
if [[ "root" != "${SCRIPT_USER}" ]];then
    echo "[ERROR] Must be run as root"
    exit 0
fi

mkdir -p /usr/hdp/${KNOX_VERSION}
hdp-select set knox-server ${KNOX_VERSION}

