#!/bin/bash

add-apt-repository ppa:ondrej/php -y
apt-get update -y

apt-get install -y php7.1 php7.1-fpm php7.1-curl php7.1-dev php7.1-gd php7.1-intl \
                   php7.1-mcrypt php7.1-json php7.1-mysql php7.1-sqlite \
                   php7.1-opcache php7.1-bcmath php7.1-mbstring php7.1-soap php7.1-xml \
                   php7.1-dom php7.1-mbstring php7.1-zip

apt-get install libapache2-mod-php7.1 -y
a2dismod php5
a2enmod php7.1
a2enconf php7.1-fpm
a2enmod proxy_fcgi setenvif
service apache2 restart
service apache2 stop

apt-get install gcc make autoconf libc-dev pkg-config -y

bash -c "echo extension=apcu.so > /etc/php/7.1/cli/conf.d/20-apcu.ini"
bash -c "echo extension=apcu.so > /etc/php/7.1/fpm/conf.d/20-apcu.ini"
bash -c "echo extension=apcu.so > /etc/php/7.1/apache2/conf.d/20-apcu.ini"

sed -i 's/user = www-data/user = ubuntu/g' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = ubuntu/g' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/listen.owner = www-data/listen.owner = ubuntu/g' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/pm = dynamic/pm = ondemand/g' /etc/php/7.1/fpm/pool.d/www.conf
sed -i 's/;request_terminate_timeout = 0/request_terminate_timeout = 300/g' /etc/php/7.1/fpm/pool.d/www.conf

sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php/7.1/fpm/php.ini

sleep 5
#wget https://raw.githubusercontent.com/wodby/drupal-nginx/master/1.10/fastcgi_params -O /etc/nginx/fastcgi_params

wget https://raw.githubusercontent.com/SuperNami/c9-nginx-php7/master/drupal.conf -O /etc/nginx/sites-available/drupal.conf
ln -s /etc/nginx/sites-available/drupal.conf /etc/nginx/sites-enabled/drupal.conf

wget https://raw.githubusercontent.com/SuperNami/c9-nginx-php7/master/nginx.conf -O /etc/nginx/nginx.conf

# helper utility
wget https://raw.githubusercontent.com/SuperNami/c9-nginx-php7/master/lemp -O /usr/bin/lemp
chmod 755 /usr/bin/lemp

# update Composer
composer self-update

# start
sleep 5
service nginx start
service nginx reload
service php7.1-fpm start
mysql-ctl start

# status
sleep 5
service nginx status
service php7.1-fpm status
service mysql status

# this command stops the script with user input where you have to hit [enter] key
pecl install apcu -y

# restart workspace for filesystem paths to change to "/home/ubuntu/workspace"
# curl -L https://raw.githubusercontent.com/SuperNami/c9-nginx-php7/master/script.sh | bash

echo "export PATH=$PATH:/home/ubuntu/workspace/vendor/bin" >> /home/ubuntu/.bashrc
