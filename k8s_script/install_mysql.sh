#!/bin/bash
wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm

rpm -ivh mysql57-community-release-el7-9.noarch.rpm

yum install mysql-server -y

# 修改root密码
vi /etc/my.cnf
加上一行 skip-grant-tables

启动 service mysqld start 

update mysql.user set authentication_string = password('admin') where user='root';

flush privileges

vi /etc/my.cnf  删除skip-grant-tables

service mysqld restart

# 开启binlog
log-bin=/var/lib/mysql/mysql-bin
server-id=1
