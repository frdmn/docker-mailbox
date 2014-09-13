#!/usr/bin/env bash
. /tmp/settings.conf

sed -i -e "s/%primaryhost%/${MAILHOSTNAME}/g" /etc/php5/fpm/php.ini
