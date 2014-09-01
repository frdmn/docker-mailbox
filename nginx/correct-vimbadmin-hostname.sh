#!/usr/bin/env bash
. /tmp/settings.conf

sed -i 's/vimbadmin\.myserver\.com/'${VIMBHOST}'/g' /etc/nginx/sites-available/vimbadmin
