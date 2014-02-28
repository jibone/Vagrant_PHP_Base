#!/bin/sh
apt-get update
apt-get upgrade
apt-get install -y build-essential openssl curl zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison git-core git
apt-get install -y vim
echo mysql-server mysql-server/root_password select "vagrant" | debconf-set-selections
echo mysql-server mysql-server/root_password_again select "vagrant" | debconf-set-selections
apt-get install -y mysql-server 
apt-get install -y apache2
apt-get install -y python-software-properties
add-apt-repository ppa:ondrej/php5
apt-get update
apt-get install -y php5 php5-cli php5-mcrypt php5-mysql libapache2-mod-php5
VHOST=$(cat <<EOF
<VirtualHost *:80>
  DocumentRoot "/vagrant/web/public"
  ServerName localhost
  <Directory "/vagrant/web/public">
    AllowOverride All
  </Directory>
</VirtualHost>
EOF
)
touch /etc/apache2/sites-available/web
echo "${VHOST}" > /etc/apache2/sites-available/web
echo "ServerName localhost" > /etc/apache2/httpd.conf
mkdir /vagrant/web
mkdir /vagrant/web/public
echo "<?php phpinfo(); ?>" > /vagrant/web/public/index.php
sudo a2enmod rewrite actions fastcgi alias
sudo a2dissite default
sudo a2ensite web
sudo service apache2 restart
apt-get clean
