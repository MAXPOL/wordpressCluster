WS1

yum -y install epel-release
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils
yum-config-manager --enable remi-php73

touch /etc/yum.repos.d/MariaDB.repo
echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo
echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "baseurl = http://yum.mariadb.org/10.0/centos7-amd64" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo

yum -y install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json
yum -y install httpd nano wget unzip
yum -y install MariaDB-server MariaDB-client


systemctl start mysql
systemctl enable mysql
systemctl start httpd
systemctl enable httpd  

mysql_secure_installation
ENTER
y
1
1
y
n
y
y

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

mysql -u root -p1  -e "CREATE USER 'user'@'%' IDENTIFIED BY '1';"
mysql -u root -p1  -e "CREATE DATABASE wp CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -u root -p1  -e "GRANT ALL PRIVILEGES ON *.* TO 'user'@'%';"
mysql -u root -p1  -e "FLUSH PRIVILEGES;"

firewall-cmd --permanent --zone=public --add-port=3306/tcp --add-port=80/tcp

cd /var/www/html
wget https://ru.wordpress.org/latest-ru_RU.zip

unzip latest-ru_RU.zip

mv wordpress wp

chmod 0777 wp

reboot

Заходим в бразуер http://ip_server_1/wp и настраиваем
в поле HOST указамыем ip адрес сервера (НЕ localhost)

systemctl stop httpd
cd /var/www/html
tar -cvf wp.tar.gz wp/*
systemctl start httpd

WS2

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
wget http://IP_ADDRESS/wp.tar.gz
tar -xvf wp.tar.gz

reboot

Заходим в бразуер http://ip_server_2/wp и должен отобразиться настронный сайт

Переходим на 1 первый сервер и доделывем балансировку нагрузки:

WS1

yum -y install haproxy -y

cd /etc/haproxy

mv haproxy.cfg haproxy.cfg_backup

nano haproxy.cfg

global
   log /dev/log local0
   log /dev/log local1 notice
   chroot /var/lib/haproxy
   stats timeout 30s
   user haproxy
   group haproxy
   daemon

defaults
   log global
   mode http
   option httplog
   option dontlognull
   timeout connect 5000
   timeout client 50000
   timeout server 50000

frontend http_front
   bind *:70
   stats uri /haproxy?stats
   default_backend http_back

backend http_back
   balance roundrobin
   server ws1 ip_address_ws1:80 check
   server ws2 ip_address_ws2:80 check

####

firewall-cmd --permanent --zone=public --add-port=70/tcp
firewall-cmd --reload

systemctl start haproxy
systemctl enable haproxy

Вводим в браузере http://ip_address_1:70/wp
