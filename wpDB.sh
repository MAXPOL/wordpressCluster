yum -y install epel-release
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils
yum -y install nano wget unzip

touch /etc/yum.repos.d/MariaDB.repo
echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo
echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "baseurl = http://yum.mariadb.org/10.0/centos7-amd64" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo

yum -y install MariaDB-server MariaDB-client

systemctl start mysql
systemctl enable mysql 

mysql_secure_installation <<EOF

y
1
1
y
n
y
y
EOF

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

mysql -u root -p1  -e "CREATE USER 'user'@'%' IDENTIFIED BY '1';"
mysql -u root -p1  -e "CREATE DATABASE wp CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -u root -p1  -e "GRANT ALL PRIVILEGES ON *.* TO 'user'@'%';"
mysql -u root -p1  -e "FLUSH PRIVILEGES;"


firewall-cmd --permanent --zone=public --add-port=3306/tcp

reboot

