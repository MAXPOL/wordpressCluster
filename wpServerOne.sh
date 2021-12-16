yum -y install epel-release
yum -y install  nano wget  -y

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload


# After full config: systemctl stop httpd && cd /var/www/html && tar -cvf wp.tar.gz wp/* && systemctl start httpd
