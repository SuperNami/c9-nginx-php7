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
a2enconf php7.0-fpm
a2enmod proxy_fcgi setenvif
service apache2 restart
service apache2 stop

apt-get install gcc make autoconf libc-dev pkg-config -y

bash -c "echo extension=apcu.so > /etc/php/7.0/cli/conf.d/20-apcu.ini"
bash -c "echo extension=apcu.so > /etc/php/7.0/fpm/conf.d/20-apcu.ini"
bash -c "echo extension=apcu.so > /etc/php/7.0/apache2/conf.d/20-apcu.ini"

sed -i 's/user = www-data/user = ubuntu/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = ubuntu/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/listen.owner = www-data/listen.owner = ubuntu/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/pm = dynamic/pm = ondemand/g' /etc/php/7.0/fpm/pool.d/www.conf

sleep 5
#wget https://raw.githubusercontent.com/wodby/drupal-nginx/master/1.10/fastcgi_params -O /etc/nginx/fastcgi_params

wget https://raw.githubusercontent.com/SuperNami/c9-nginx-php7/master/drupal1.conf -O /etc/nginx/sites-available/drupal.conf
#wget https://raw.githubusercontent.com/SuperNami/c9-nginx-php7/master/drupal2.conf -O /etc/nginx/sites-available/drupal.conf
ln -s /etc/nginx/sites-available/drupal.conf /etc/nginx/sites-enabled/drupal.conf

wget https://raw.githubusercontent.com/SuperNami/c9-nginx-php7/master/nginx.conf -O /etc/nginx/nginx.conf

# helper utility
wget https://raw.githubusercontent.com/GabrielGil/c9-lemp/master/lemp -O /usr/bin/lemp
chmod 755 /usr/bin/lemp

# update Composer
composer self-update

# start
sleep 5
service nginx start
service nginx reload
service php7.0-fpm start
mysql-ctl start

# status
sleep 5
service nginx status
service php7.0-fpm status
service mysql status

# this command stops the script with user input where you have to hit [enter] key
pecl install apcu -y

# restart workspace for filesystem paths to change to "/home/ubuntu/workspace"
# curl -L https://raw.githubusercontent.com/SuperNami/c9-nginx-php7/master/script.sh | bash

echo "export PATH=$PATH:/home/ubuntu/workspace/vendor/bin" >> /home/ubuntu/.bashrc
