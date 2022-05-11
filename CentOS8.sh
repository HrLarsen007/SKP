## opsætning af en webserver på Centos 8.

## Opdater CentOS

sudo yum -y update && yum -y upgrade
sudo yum -y clean all


## Installere nogle brugebar pakker til systemet samt Remi og epel til at bruge til at installere PHP

sudo yum -y install yum-utils
sudo yum -y install epel-release

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-8.rpm

sudo yum -y update && yum -y upgrade

## installing Apache
sudo yum install -y httpd


## Fjerner alt PHP der ligger i forvejen
sudo yum -y remove php php-fpm
sudo yum -y remove php*
sudo yum -y module list reset php
sudo yum -y module reset php


## Enabler php:remi-8.1 repo så vi kan download fra det
sudo yum -y module enable php:remi-8.1

## Installere PHP via remi repo
sudo yum -y install php

## Installere alle pakker til PHP (Bedst pratice er kun at installer dem vi skal bruge)
sudo yum -y install php-cli php-fpm php-curl php-mysqlnd php-gd php-opcache php-zip php-intl php-common php-bcmath php-imap php-imagick php-xmlrpc php-json php-readline php-memcached php-redis php-mbstring php-apcu php-xml php-ldap php-fileinfo php-pdo

sudo yum -y update && yum -y upgrade

## laver en test side til at se vores php indstillinger
touch /var/www/html/phpinfo.php && echo '<?php phpinfo(); ?>' >> /var/www/html/phpinfo.php 

## Installere database (mariadb)
sudo yum -y install mariadb-server mariadb

## installere nogle quality of life værktøjer
sudo yum -y install nano wget curl net-tools git rsync 

## Installere perl relateret pakker, i tilfælde af der skal køres perl scripts.
sudo yum -y install perl perl-Net-SSLeay unzip perl-Encode-Detect perl-Data-Dumper

## Strater og sætter services til at start op når maskine starter.
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service

sudo yum -y update && yum -y upgrade

## installere database (mariadb/mysql)
sudo mysql_secure_installation

## Sætter rettighederene til apache
sudo chmod 755 /var/www -R
sudo chown apache:apache /var/www/html/* -R 

## Firewall regler (kun hvis der skal være adgang udenfor local host)
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp ##Database (mariadb)
sudo firewall-cmd --reload


## laver en focus update på selinux-policy
sudo yum update -y selinux-policy*

## Genstarter systemerne
sudo systemctl restart httpd.service
sudo systemctl restart mariadb.service

## vi kan teste vore system 
php -v
php --version

if `mysql -u root -p`; then
	echo "DB connection successfull"
else
	echo "DB connection failed"
fi