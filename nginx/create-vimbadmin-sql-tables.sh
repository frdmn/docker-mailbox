#!/usr/bin/env bash
. /tmp/settings.conf

/usr/sbin/mysqld &
sleep 5
php /var/www/vimbadmin/bin/doctrine2-cli.php orm:schema-tool:create