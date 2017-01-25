#!/bin/bash

add-apt-repository ppa:ondrej/php -y
apt-get update -y

apt-get install -y php7.0-curl php7.0-dev php7.0-gd php7.0-intl \
                   php7.0-mcrypt php7.0-json php7.0-mysql php7.0-sqlite \
                   php7.0-opcache php7.0-bcmath php7.0-mbstring php7.0-soap php7.0-xml \
                   php7.0-dom php7.0-mbstring php7.0-zip

apt-get install libapache2-mod-php7.0 -y
a2dismod php5
a2enmod php7.0

apt-get install gcc make autoconf libc-dev pkg-config -y
pecl install apcu -y

bash -c "echo extension=apcu.so > /etc/php/7.0/cli/conf.d/20-apcu.ini"
bash -c "echo extension=apcu.so > /etc/php/7.0/fpm/conf.d/20-apcu.ini"
bash -c "echo extension=apcu.so > /etc/php/7.0/apache2/conf.d/20-apcu.ini"

service apache2 restart

#wget https://raw.githubusercontent.com/wodby/drupal-nginx/master/1.10/fastcgi_params
wget https://raw.githubusercontent.com/wodby/drupal-nginx/master/1.10/nginx.conf -O /etc/nginx/nginx.conf
wget https://raw.githubusercontent.com/wodby/drupal-nginx/master/1.10/drupal8.conf -O /etc/nginx/sites-available/drupal8.conf
