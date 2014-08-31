. /tmp/settings.conf

/usr/sbin/mysqld &
sleep 5
echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '"${MYSQLROOT}"' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql
