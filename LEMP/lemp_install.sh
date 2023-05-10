#!/bin/bash

# Update the package manager
sudo apt-get update

# Install Nginx web server
sudo apt-get install nginx -y

# Install MySQL database server
sudo apt-get install mysql-server -y

# Secure the MySQL installation by running the mysql_secure_installation script
sudo mysql_secure_installation

# Install PHP and necessary extensions
sudo apt-get install php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc -y

# Configure Nginx to use PHP-FPM
sudo sed -i 's/#location \~ \\.php/location \~ \\.php/g' /etc/nginx/sites-available/default
sudo sed -i 's/#\tinclude snippets\/fastcgi-php.conf;/\tinclude snippets\/fastcgi-php.conf;/g' /etc/nginx/sites-available/default
sudo sed -i 's/#\tfastcgi_pass unix:\/var\/run\/php\/php7.2-fpm.sock;/\tfastcgi_pass unix:\/var\/run\/php\/php7.2-fpm.sock;/g' /etc/nginx/sites-available/default

# Restart Nginx and PHP-FPM services
sudo systemctl restart nginx
sudo systemctl restart php7.2-fpm
