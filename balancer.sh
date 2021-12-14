yum -y install epel-release
yum -y install nano wget haproxy ansible -y

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
   bind *:80
   stats uri /haproxy?stats
   default_backend http_back

backend http_back
   balance roundrobin
   server ws1 ip_address_ws1:80 check
   server ws2 ip_address_ws2:80 check

****

firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload

systemctl start haproxy
systemctl enable haproxy
