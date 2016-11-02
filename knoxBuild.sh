#!/bin/bash
###############################################################################
## Script to build Apache Knox on the Command Line
## Uses build.sh with options to
##  increase memory
##  dump memory on crash dump
##  use a profile (optional)
## John McParland
## M 17 Oct 2016
###############################################################################

if [[ -f ${HOME}/.bash_cysafa ]];then
    . ${HOME}/.bash_cysafa
else 
   echo "WARNING: No ${HOME}/.bash_cysafa file"
fi

# Optionally, use a profile
if [[ 1 -eq ${#} ]];then
   PROFILE="-P ${1}"
fi

# Allow heapdumps from Java
ulimit -c unlimited

# Remove these files which tend to cause the maven-rat-plugin to die
find . -type f -name 'hs_err_pid*.log' -exec rm {} \;
find . -type f -name '*build.log' -exec rm {} \;
find . -type f -name core -exec rm {} \;

# -m: increase memory
# -c: dump memory on crash dump
# -P: use a profile
${ODSC_KNOX_LOCATION}/build.sh -m -c -g"clean install" ${PROFILE}

