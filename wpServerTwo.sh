yum -y install epel-release
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils
yum-config-manager --enable remi-php73
yum -y install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json
yum -y install httpd nano wget unzip -y

systemctl enable httpd

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

firewall-cmd --permanent --zone=public --add-port=80/tcp

cd /var/www/html
wget http://192.168.0.103/wp.tar.gz
tar -xvf wp.tar.gz

reboot
