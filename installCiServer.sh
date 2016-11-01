#!/bin/bash
###############################################################################
## Install the necessary software on the CI Server
## John McParland
## Th 27 Oct 2016
###############################################################################

# Remove OpenJDK
sudo apt-get purge openjdk*
sudo apt-get autoremove

# Java 8
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" >> ${HOME}/.bash_aliases

# Maven
sudo apt install maven

# Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins

## MySQL
sudo apt-get install mysql-server
mysql -u root

# On MySQL Command Line
#create user 'sonarqube'@'localhost' identified by -- 'xxx';
#create database sonarqube default character set utf8 default collate utf8_general_ci;
#grant all on sonarqube.* to 'sonarqube'@'localhost';

# SonarQube
echo "deb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/" >> /etc/apt/sources.list
sudo apt-get update
sudo apt-get install sonar

