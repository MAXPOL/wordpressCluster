yum -y install epel-release
yum -y install docker nano wget  -y

systemctl start docker
systemctl enable docker

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload

cd /ws
docker build -t ws .
docker run -d --name ws -p 80:80 -ti ws /bin/bash
docker exec apache2 start


# After full config: systemctl stop httpd && cd /var/www/html && tar -cvf wp.tar.gz wp/* && systemctl start httpd
