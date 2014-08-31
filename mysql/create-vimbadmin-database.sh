. /tmp/settings.conf

/usr/sbin/mysqld &
sleep 5
echo "CREATE DATABASE vimbadmin;GRANT ALL ON vimbadmin.* TO vimbadmin@localhost IDENTIFIED BY '"${MYSQLVIMBADMIN}"';FLUSH PRIVILEGES;" | mysql
