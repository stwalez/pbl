#!/bin/bash
hostnamectl set-hostname tooling-server
yum -y install git rpm-build make
git clone https://github.com/aws/efs-utils
cd efs-utils
make rpm
yum -y install build/amazon-efs-utils*rpm
sed -i "s/stunnel_check_cert_hostname = true/stunnel_check_cert_hostname = false/g" /etc/amazon/efs/efs-utils.conf
mkdir /var/www/
sudo mount -t efs -o tls,accesspoint=fsap-0e1b08acb7e4323ee fs-018d478f69b0acdf9:/ /var/www/
cd ~
yum install -y httpd 
systemctl start httpd
systemctl enable httpd
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm       
wget https://rpms.remirepo.net/enterprise/remi-release-7.rpm                      
rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm                      
yum-config-manager --enable remi-php74                         
yum install -y php php-common php-mbstring php-opcache php-intl php-xml php-gd php-curl php-mysqlnd php-fpm php-json                   
sudo systemctl start php-fpm                                                      
sudo systemctl enable php-fpm
git clone https://github.com/stwalez/tooling.git
mkdir /var/www/html
cp -R tooling/html/*  /var/www/html/
cd tooling
mysql -h <insert_db_host_here> -u <insert_db_username_here> -p<insert_db_pw_here> -e "create database toolingdb"
mysql -h <insert_db_host_here> -u <insert_db_username_here> -p<insert_db_pw_here> toolingdb < tooling-db.sql
cd /var/www/html/
touch healthstatus
sed -i "s/$db = mysqli_connect('mysql.tooling.svc.cluster.local', 'admin', 'admin', 'tooling');/$db = mysqli_connect('<insert_db_host_here>', '<insert_db_username_here>', '<insert_db_pw_here>', 'toolingdb');/g" functions.php
setsebool -P httpd_use_nfs 1
setsebool -P httpd_can_network_connect=1
setsebool -P httpd_execmem=1
yum install -y mod_ssl
systemctl restart httpd