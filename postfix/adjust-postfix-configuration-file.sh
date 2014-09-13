#!/usr/bin/env bash
. /tmp/settings.conf

sed -i -e "s/%primaryhost%/${MAILHOSTNAME}/g" /etc/postfix/main.cf
