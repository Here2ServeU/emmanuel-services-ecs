#!/bin/bash
# Update system packages
sudo apt-get update -y && sudo apt-get upgrade -y

# Remove Existing Java Versions and Install Java 21 (OpenJDK)
sudo apt remove --purge openjdk-\*
sudo apt autoremove -y
sudo apt update
sudo apt install -y openjdk-21-jdk
java -version

# Add Jenkins repository and key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
# Update package list and install Jenkins
sudo apt-get update -y
sudo apt-get install -y jenkins

# Enable and start Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Verify Jenkins status
sudo systemctl status jenkins