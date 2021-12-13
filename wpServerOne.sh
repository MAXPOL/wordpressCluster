yum -y install epel-release
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils
yum-config-manager --enable remi-php73
yum -y install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json
yum -y install httpd nano wget unzip -y

systemctl enable httpd

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

cd /var/www/html
wget https://ru.wordpress.org/latest-ru_RU.zip

unzip latest-ru_RU.zip

mv wordpress wp

chmod 0777 wp

firewall-cmd --permanent --zone=public --add-port=80/tcp

reboot

# After full config: cd /var/www/html && tar -cvf wp.tar.gz wp/*
