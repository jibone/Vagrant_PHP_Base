#!/bin/sh
apt-get update
apt-get install -y build-essential openssl curl zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison git-core git
apt-get install -y vim
echo mysql-server mysql-server/root_password select "vagrant" | debconf-set-selections
echo mysql-server mysql-server/root_password_again select "vagrant" | debconf-set-selections
apt-get install -y mysql-server 
apt-get install -y apache2
apt-get install -y php5 php5-cli php5-mcrypt php5-mysql libapache2-mod-php5
VHOST=$(cat <<EOF
<VirtualHost *:80>
  DocumentRoot "/vagrant/web"
  ServerName localhost
  <Directory "/vagrant/web">
    AllowOverride All
  </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-enable/000-default
sudo a2enmod rewrite
sudo service apache2 restart
apt-get clean
