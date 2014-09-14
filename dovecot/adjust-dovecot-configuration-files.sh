#!/usr/bin/env bash
. /tmp/settings.conf

sed -i -e "s/%postmaster%/${POSTMASTER}/g" /etc/dovecot/conf.d/15-lda.conf
sed -i -e "s/%mailhostname%/${MAILHOSTNAME}/g" /etc/dovecot/conf.d/15-lda.conf
sed -i -e "s/%mailhostname%/${MAILHOSTNAME}/g" /etc/dovecot/conf.d/20-lmtp.conf
