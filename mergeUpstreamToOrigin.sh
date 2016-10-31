#!/bin/bash
###############################################################################
## Merges upstream (apache/knox) into the origin (mcparlandjcgi/knox)
## John McParland
## M 31 Oct 2016
###############################################################################

cd ${HOME}/git/knox
git fetch upstream
git checkout master
git merge upstream/master

