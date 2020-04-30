#install script for Docker CE on a Centos 8 Operating System
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
echo "Computer Says - Repository added"
sudo yum install docker-ce docker-ce-cli containerd.io -y
echo "Computer Says - Installation Complete"
echo "Computer Says - Starting Docker"
sudo systemctl start docker
echo "Computer Says - Checking Docker Status"
sudo docker run hello-world
echo "Computer Says - Script Complete."