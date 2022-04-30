#!/bin/bash
hostnamectl set-hostname nginx-rp-server
yum -y install nginx git rpm-build make
systemctl enable --now nginx
git clone https://github.com/aws/efs-utils
cd efs-utils
make rpm
yum -y install build/amazon-efs-utils*rpm
sed -i "s/stunnel_check_cert_hostname = true/stunnel_check_cert_hostname = false/g" /etc/amazon/efs/efs-utils.conf
mount -t efs -o tls,accesspoint=fsap-06e1daa069b75e66d fs-018d478f69b0acdf9:/ /var/log/nginx/
setsebool -P httpd_use_nfs 1
cd ~
git clone https://github.com/stwalez/acs-config.git
mkdir -p /etc/ssl/private
chmod 700 /etc/ssl/private
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ACS.key -out /etc/ssl/certs/ACS.crt -config acs-config/req.conf
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
mv acs-config/nginx.conf /etc/nginx/nginx.conf
chcon -t httpd_config_t /etc/nginx/nginx.conf
mkdir -p /var/www/html             
touch /var/www/html/healthstatus
systemctl restart nginx
rm -rf acs-config