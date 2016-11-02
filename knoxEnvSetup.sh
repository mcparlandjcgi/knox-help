###############################################################################
## Setup the environment to aid working on Apache Knox
## John McParland
## Th 20 Oct 2016
###############################################################################

KNOX_HELP_LOCATION=`pwd -P`

# Check .bash_aliases exists (it should!)
if [[ ! -f ${HOME}/.bash_aliases ]];then
    touch ${HOME}/.bash_aliases
    echo '. ${HOME}/.bash_aliases' >> ${HOME}/.bashrc
fi

# Put out properties in a file to be sourced
BASH_KNOX=${KNOX_HELP_LOCATION}/.bash_knox

if [[ ! -f ${HOME}/.bash_knox ]];then
    touch ${HOME}/.bash_knox
    # Ensure we include the location of the repo!
    echo "export KNOX_HELP_LOCATION=${KNOX_HELP_LOCATION}" >> ${HOME}/.bash_knox
    echo 'export PATH=${PATH}:${KNOX_HELP_LOCATION}' >> ${HOME}/.bash_knox
    echo "Enter the IP/DNS of the HDP server then press [ENTER]: "
    read KNOX_HDP
    echo "export KNOX_HDP=${KNOX_HDP}" >> ${HOME}/.bash_knox
fi

# Ensure our new file gets included in the environment
echo "" >> ${HOME}/.bash_aliases
echo "# Knox Help Additions" >> ${HOME}/.bash_aliases
echo "#####################" >> ${HOME}/.bash_aliases
echo 'if [[ -f ${HOME}/.bash_knox ]];then' >> ${HOME}/.bash_aliases
echo '    . ${HOME}/.bash_knox' >> ${HOME}/.bash_aliases
echo "fi" >> ${HOME}/.bash_aliases

. ${HOME}/.bash_knox

# Checkout git repos
cd ${HOME}
if [[ ! -d git ]];then
    mkdir git
fi

cd git
git clone git@github.com:mcparlandjcgi/knox.git
cd knox
git remote add upstream git://git.apache.org/knox.git
git remote -v 
cd ${KNOX_HELP_LOCATION}

