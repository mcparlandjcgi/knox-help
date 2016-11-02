#!/bin/bash
###############################################################################
## Perform a SonarQube analysis
## Args
##  1: Authentication Token for SonarQube user who can analyse projects.
## John McParland
## Tu 1 Nov 2016
###############################################################################

if [[ 1 -ne ${#} ]];then
    echo "[ERROR] Requires one argument - the authentication of the SonarQube user to analyse the project"
    exit 0
fi

SONAR_PLUGIN_GROUPID=org.sonarsource.scanner.maven
SONAR_PLUGIN_ARTEFACTID=sonar-maven-plugin
SONAR_PLUGIN_GOAL=sonar
SONAR_PLUGIN_VERSION=3.1.1
SONAR_HOST_URL=http://knoxubuntu.ukwest.cloudapp.azure.com:9000
SONAR_LOGIN=${1}

CMD="mvn ${SONAR_PLUGIN_GROUPID}:${SONAR_PLUGIN_ARTEFACTID}:${SONAR_PLUGIN_VERSION}:${SONAR_PLUGIN_GOAL} -Dsonar.host.url=${SONAR_HOST_URL} -Dsonar.login=${SONAR_LOGIN}"

echo "${CMD}"
eval ${CMD}
exit ${?}

