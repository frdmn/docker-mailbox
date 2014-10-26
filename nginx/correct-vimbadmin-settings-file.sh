#!/usr/bin/env bash
. /tmp/settings.conf

# TODO - improve sed to pass variables with special characters
sed -i 's%^securitysalt\s*=\s*\"\"$%securitysalt = \"'${VIMBSECSALT}'\"%g' /var/www/vimbadmin/application/configs/application.ini
sed -i 's%^resources.auth.oss.rememberme.salt\s*=\s*\"\"$%resources.auth.oss.rememberme.salt = \"'${VIMBREMEMBERSALT}'\"%g' /var/www/vimbadmin/application/configs/application.ini
sed -i 's%^defaults.mailbox.password_salt\s*=\s*\"\"$%defaults.mailbox.password_salt = \"'${VIMBPASSSALT}'\"%g' /var/www/vimbadmin/application/configs/application.ini
sed -i 's%^defaults.mailbox.uid\s*=\s*2000$%defaults.mailbox.uid = 5000%g' /var/www/vimbadmin/application/configs/application.ini
sed -i 's%^defaults.mailbox.gid\s*=\s*2000$%defaults.mailbox.gid = 5000%g' /var/www/vimbadmin/application/configs/application.ini
sed -i 's%^defaults.mailbox.homedir\s*=\s*\"[a-zA-Z0-9_\/%]*\"$%defaults.mailbox.homedir = \"\/var\/vmail\/\"%g' /var/www/vimbadmin/application/configs/application.ini
sed -i 's%^defaults.mailbox.maildir\s*=\s*\"maildir:/srv/vmail/\%d/\%u/mail:LAYOUT=fs\"%defaults.mailbox.maildir = "maildir:/var/vmail/\%d/\%u/mail:LAYOUT=fs"%g' /var/www/vimbadmin/application/configs/application.ini
sed -i "s%^resources.doctrine2.connection.options.password\s*=\s*'[a-zA-Z0-9]*'$%resources.doctrine2.connection.options.password = '${MYSQLVIMBADMIN}'%g" /var/www/vimbadmin/application/configs/application.ini
sed -i 's%^identity.email\s*=\s*"support@example.com"%identity.email = "support@'${PRIMARYHOSTNAME}'"%g' /var/www/vimbadmin/application/configs/application.ini
sed -i 's%^server.email.address\s*=\s*"support@example.com"%server.email.address = "support@'${PRIMARYHOSTNAME}'"%g' /var/www/vimbadmin/application/configs/application.ini
sed -i 's%^defaults.mailbox.password_scheme\s*=\s*"md5.salted"%defaults.mailbox.password_scheme = "md5"%g' /var/www/vimbadmin/application/configs/application.ini
# TODO - check if not needed?
#sed -i "s%^resources.doctrine2.connection.options.host\s*=\s*'localhost'$%resources.doctrine2.connection.options.host = '127.0.0.1'%g" /var/www/vimbadmin/application/configs/application.ini
#sed -i 's%^resources.session.save_path$%;resources.session.save_path%g' /var/www/vimbadmin/application/configs/application.ini
