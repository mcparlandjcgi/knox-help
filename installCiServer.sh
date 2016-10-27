#!/bin/bash
###############################################################################
## Install the necessary software on the CI Server
## John McParland
## Th 27 Oct 2016
###############################################################################

# Maven
sudo apt install maven

# Java 8
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer

# Jenkins

