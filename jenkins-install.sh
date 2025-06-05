#!/bin/bash

# Reference: https://www.cherryservers.com/blog/install-jenkins-ubuntu  and  https://www.jenkins.io/doc/book/installing/linux/#debianubuntu
# This file will install the Jenkins in the Ubuntu flavour.
# Update and Upgrade existing packages in the Ubuntu
sudo apt update -y 
sudo apt upgrade -y 

# Install Java Open JDK 17
sudo apt install -y openjdk-17-jdk

# Adding Jenkins Repository
# Import Jenkins GPG key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
# Adding Jenkins repository into server's sources.list
sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update the packages in the Ubuntu after adding the Jenkins repo
sudo apt update -y

# Install Jenkins packages in the server
sudo apt install jenkins -y

# Start and Enable the Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check the status of the Java and Jenkins
sudo java --version
sudo systemctl status jenkins