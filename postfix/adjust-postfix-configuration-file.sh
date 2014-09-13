#!/usr/bin/env bash
. /tmp/settings.conf

sed -i -e "s/%mailhostname%/${MAILHOSTNAME}/g" /etc/postfix/main.cf
sed -i -e "s/%primaryhostname%/${PRIMARYHOSTNAME}/g" /etc/postfix/main.cf
