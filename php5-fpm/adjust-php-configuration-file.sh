#!/usr/bin/env bash
. /tmp/settings.conf

sed -i -e "s/short_open_tag = Off/short_open_tag = On/g" /etc/php5/fpm/php.ini
sed -i -e "s/post_max_size = 8M/post_max_size = 20M/g" /etc/php5/fpm/php.ini
sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php5/fpm/php.ini
echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
echo "max_input_vars = 10000;" >> /etc/php5/fpm/php.ini
echo "date.timezone = Europe/London;" >> etc/php5/fpm/php.ini
