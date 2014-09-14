#!/usr/bin/env bash
. /tmp/settings.conf

rm /etc/ssl/certs/dovecot.pem /etc/ssl/private/dovecot.pem
openssl req -new -x509 -days 3650 -nodes -out /etc/ssl/certs/dovecot.pem -keyout /etc/ssl/private/dovecot.pem -subj "/C=DE/ST=Bavaria/L=Wuerzburg/O=Company/OU=mailbox/CN=${MAILHOSTNAME}"
