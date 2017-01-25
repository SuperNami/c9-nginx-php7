#!/bin/bash

add-apt-repository ppa:ondrej/php -y
apt-get update -y

apt-get install -y php7.0 php7.0-fpm php7.0-curl php7.0-dev php7.0-gd php7.0-intl \
                   php7.0-mcrypt php7.0-json php7.0-mysql php7.0-sqlite \
                   php7.0-opcache php7.0-bcmath php7.0-mbstring php7.0-soap php7.0-xml \
                   php7.0-dom php7.0-mbstring php7.0-zip

apt-get install libapache2-mod-php7.0 -y
a2dismod php5
a2enmod php7.0
service apache2 restart
service apache2 stop

apt-get install gcc make autoconf libc-dev pkg-config -y
pecl install apcu -y

bash -c "echo extension=apcu.so > /etc/php/7.0/cli/conf.d/20-apcu.ini"
bash -c "echo extension=apcu.so > /etc/php/7.0/fpm/conf.d/20-apcu.ini"
bash -c "echo extension=apcu.so > /etc/php/7.0/apache2/conf.d/20-apcu.ini"

#wget https://raw.githubusercontent.com/wodby/drupal-nginx/master/1.10/fastcgi_params -O /etc/nginx/fastcgi_params
wget https://raw.githubusercontent.com/SuperNami/c9-nginx-php7/master/drupal8.conf -O /etc/nginx/sites-available/drupal8.conf
ln -s /etc/nginx/sites-available/drupal8.conf /etc/nginx/sites-enabled/drupal8.conf

wget https://raw.githubusercontent.com/GabrielGil/c9-lemp/master/lemp -O /usr/bin/lemp
chmod 755 /usr/bin/lemp

# update Composer
composer self-update

service nginx start
service nginx reload
service php7.0-fpm start
mysql-ctl start

sleep 5
service nginx status
service php7.0-fpm status
service mysql status

# curl -L https://raw.githubusercontent.com/SuperNami/c9-nginx-php7/master/script.sh | bash
