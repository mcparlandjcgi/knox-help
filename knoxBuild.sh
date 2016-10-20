#!/bin/bash
###############################################################################
## Script to build Apache Knox on the Command Line
## Uses build.sh with options to
##  skip tests
##  skip integration tests
##  increase memory
##  increase permgen size
##  dump memory on crash dump
##  skip rat checks
## John McParland
## M 17 Oct 2016
###############################################################################

if [[ -f ${HOME}/.bash_cysafa ]];then
    . ${HOME}/.bash_cysafa
else 
   echo "WARNING: No ${HOME}/.bash_cysafa file"
fi

# Allow heapdumps from Java
ulimit -c unlimited

# -t: skip tests
# -i: skip integration tests
# -m: increase memory
# -p: increase permgen size
# -p: dump memory on crash dump
# -r: skip rat checks
${ODSC_KNOX_LOCATION}/build.sh -t -i -m -p -r


#mvn -Ppackage install

