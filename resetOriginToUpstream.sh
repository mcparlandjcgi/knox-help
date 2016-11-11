#!/bin/bash
###############################################################################
## Resets origin (mcparlandjcgi/knox) to upstream (apache/knox)
## Required when we have changes on the fork (origin) that are patched into 
## upstream.
## John McParland
## F 11 Nov 2016
###############################################################################

git fetch upstream
git checkout master
git reset --hard upstream/master  
git push origin master --force 

