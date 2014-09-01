#!/usr/bin/env bash
. /tmp/settings.conf

sed -i 's/securitysalt\s*=\s*\"\"$/securitysalt = \"'${VIMBSECSALT}'\"/g' /var/www/vimbadmin/application/configs/application.ini
sed -i 's/defaults.mailbox.uid\s*=\s*2000$/defaults.mailbox.uid = 5000/g' /var/www/vimbadmin/application/configs/application.ini
sed -i 's/defaults.mailbox.gid\s*=\s*2000$/defaults.mailbox.gid = 5000/g' /var/www/vimbadmin/application/configs/application.ini
sed -i 's/defaults.mailbox.homedir\s*=\s*\"[a-zA-Z0-9_\/%]*\"$/defaults.mailbox.homedir = \"\/var\/vmail\/\"/g' /var/www/vimbadmin/application/configs/application.ini
sed -i "s/resources.doctrine2.connection.options.password\s*=\s*\'password\'$/resources.doctrine2.connection.options.password = \'"${MYSQLVIMBADMIN}"\'/g" /var/www/vimbadmin/application/configs/application.ini