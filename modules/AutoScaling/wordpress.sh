#!/bin/bash
hostnamectl set-hostname wordpress-server
yum -y install git rpm-build make
git clone https://github.com/aws/efs-utils
cd efs-utils
make rpm
yum -y install build/amazon-efs-utils*rpm
sed -i "s/stunnel_check_cert_hostname = true/stunnel_check_cert_hostname = false/g" /etc/amazon/efs/efs-utils.conf
mkdir /var/www/
mount -t efs -o tls,accesspoint=fsap-0c4988a080658a1ce fs-018d478f69b0acdf9:/ /var/www/
yum install -y httpd 
systemctl start httpd
systemctl enable httpd
cd ~
echo "installing php"
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm       
wget https://rpms.remirepo.net/enterprise/remi-release-7.rpm                      
rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm                      
yum-config-manager --enable remi-php74                         
yum install -y php php-common php-mbstring php-opcache php-intl php-xml php-gd php-curl php-mysqlnd php-fpm php-json                   
sudo systemctl start php-fpm                                                      
sudo systemctl enable php-fpm
echo "installing wordpress"                                                     
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
rm -rf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
mkdir /var/www/html/
cp -R wordpress/* /var/www/html/
cd /var/www/html/
touch healthstatus
sed -i "s/localhost/<insert_db_host_here>/g" wp-config.php 
sed -i "s/username_here/<insert_username-here>/g" wp-config.php 
sed -i "s/password_here/<insert_password-here>/g" wp-config.php 
sed -i "s/database_name_here/<insert_database-here>/g" wp-config.php
echo "setting selinux permissions"
setsebool -P httpd_use_nfs 1
setsebool -P httpd_can_network_connect=1
setsebool -P httpd_execmem=1
yum install -y mod_ssl
systemctl restart httpd