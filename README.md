# Install Scripts
 Various installation scripts.

 # Installl Docker CE on a Centos Linux 8
 Once Cloned, enter the install directory and run 
 sudo bash docker_ce_centos_8.sh
 This configuration script will install the latest edition of Docker CE without doing a check for current repo for docker in yum.conf.d and will not uninstal previous installations of docker.

# NGINX Plus Docker Container
 Added the process for installing NGINX Plus on a docker container.

 You will need to login to your NGINX CS portal at https://cs.nginx.com and download your nginx-repo.crt and nginx-repo.key to the nginx_plus/ssl directory.