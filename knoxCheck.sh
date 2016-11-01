#!/bin/bash
###############################################################################
## Checks Knox is running
## Tu 1 Nov 2016
###############################################################################

curl -k -u guest:guest-password -X GET "https://${KNOX_HDP}:8443/gateway/sandbox/webhdfs/v1/?op=LISTSTATUS" | python -m json.tool

