#!/bin/bash

# Update package information and install prerequisites
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the stable Docker repository
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package information and install Docker
echo "sudo apt-get update"
sudo apt-get update
echo "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sleep 2
# Start the Docker service
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
echo "sudo service docker start"
sudo service docker start


# Add the current user to the "docker" group
echo "sudo usermod -aG docker $USER"
sudo usermod -aG docker $USER
sleep 2
sudo chown "$USER":"$USER" /var/run/docker.sock -R
sudo chmod g+rwx  /var/run/docker.sock -R

sleep 2
# Test install 
echo "docker run hello-world"
docker run hello-world

# Print a message indicating the installation was successful
echo "Docker installation is complete. You may need to log out and log back in for the changes to take effect."
