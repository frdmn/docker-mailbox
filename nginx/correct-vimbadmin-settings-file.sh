#!/usr/bin/env bash
. /tmp/settings.conf

sed 's/securitysalt/'${VIMBSECSALT}'/g' /var/www/vimbadmin/application/configs/application.ini
#sed 's/mailbox.uid/'${VIMBSECSALT}'/g' /var/www/vimbadmin/application/configs/application.ini
#sed 's/mailbox.gid/'${VIMBSECSALT}'/g' /var/www/vimbadmin/application/configs/application.ini
#sed 's/mailbox.homedir/'${VIMBSECSALT}'/g' /var/www/vimbadmin/application/configs/application.ini
#sed 's/options.driver/'${VIMBSECSALT}'/g' /var/www/vimbadmin/application/configs/application.ini
#sed 's/options.dbname/'${VIMBSECSALT}'/g' /var/www/vimbadmin/application/configs/application.ini
#sed 's/options.user/'${VIMBSECSALT}'/g' /var/www/vimbadmin/application/configs/application.ini
#sed 's/options.password/'${VIMBSECSALT}'/g' /var/www/vimbadmin/application/configs/application.ini
#sed 's/options.host/'${VIMBSECSALT}'/g' /var/www/vimbadmin/application/configs/application.ini
