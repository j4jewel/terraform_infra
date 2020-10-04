#!/bin/bash

yum install httpd php -y
service httpd restart
chkconfig httpd on
MYIP=`ifconfig | grep 'addr:10' | awk '{ print $2 }' | cut -d ':' -f2`
echo 'Hello World From '$MYIP > /var/www/html/index.html
