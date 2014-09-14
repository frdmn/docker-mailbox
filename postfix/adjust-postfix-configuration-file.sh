#!/usr/bin/env bash
. /tmp/settings.conf

sed -i -e "s/%mailhostname%/${MAILHOSTNAME}/g" /etc/postfix/main.cf
sed -i -e "s/%primaryhostname%/${PRIMARYHOSTNAME}/g" /etc/postfix/main.cf

sed -i -e "s/%mysqlvimbadmin%/${MYSQLVIMBADMIN}/g" /etc/postfix/mysql/virtual_alias_maps.cf
sed -i -e "s/%mysqlvimbadmin%/${MYSQLVIMBADMIN}/g" /etc/postfix/mysql/virtual_domains_maps.cf
sed -i -e "s/%mysqlvimbadmin%/${MYSQLVIMBADMIN}/g" /etc/postfix/mysql/virtual_mailbox_maps.cf
