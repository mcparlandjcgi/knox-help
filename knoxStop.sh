#!/bin/bash
###############################################################################
## Stops Knox
## Tu 1 Nov 2016
###############################################################################

export GATEWAY_HOME=/usr/hdp/current/knox-server

${GATEWAY_HOME}/bin/gateway.sh stop
${GATEWAY_HOME}/bin/gateway.sh clean
${GATEWAY_HOME}/bin/ldap.sh stop
${GATEWAY_HOME}/bin/ldap.sh clean

