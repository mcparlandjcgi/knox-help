###############################################################################
## Setup the environment for the ODSC to work on Apache Knox
## John McParland
## Th 20 Oct 2016
###############################################################################

ODSC_KNOX_LOCATION=`pwd -P`

# Check .bash_aliases exists (it should!)
if [[ ! -f ${HOME}/.bash_aliases ]];then
    touch ${HOME}/.bash_aliases
    echo '. ${HOME}/.bash_aliases' >> ${HOME}/.bashrc
fi

# Put out properties in a file to be sourced
BASH_CYSAFA=${ODSC_KNOX_LOCATION}/.bash_cysafa

if [[ ! -f ${HOME}/.bash_cysafa ]];then
    cp ${BASH_CYSAFA} ${HOME}
    # Ensure we include the location of the repo!
    echo "export ODSC_KNOX_LOCATION=${ODSC_KNOX_LOCATION}" >> ${HOME}/.bash_cysafa
    echo 'export PATH=${PATH}:${ODSC_KNOX_LOCATION}' >> ${HOME}/.bash_cysafa
fi

# Ensure our new file gets included in the environment
echo "" >> ${HOME}/.bash_aliases
echo "CySAFA/Knox Additions" >> ${HOME}/.bash_aliases
echo "#####################" >> ${HOME}/.bash_aliases
echo 'if [[ -f ${HOME}/.bash_cysafa ]];then' >> ${HOME}/.bash_aliases
echo '    . ${HOME}/.bash_cysafa' >> ${HOME}/.bash_aliases
echo "fi" >> ${HOME}/.bash_aliases

. ${HOME}/.bash_cysafa

