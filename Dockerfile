FROM ubuntu:14.04
MAINTAINER Jonas Friedmann <j@frd.mn> version: 0.1
ENV DEBIAN_FRONTEND noninteractive

# Update locale
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

# Update apt
RUN apt-get update

# Install dependencies
RUN apt-get install -y debconf-utils mysql-server-5.5 mysql-client dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-mysql dovecot-sieve dovecot-managesieved supervisor nginx curl php5-fpm php5-pgsql php-apc php5-mcrypt php5-curl php5-gd php5-json php5-cli php5-mysql php5-memcache php5-cgi git

# Configure MySQL
RUN sed -i -e "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
ADD settings.conf /tmp/settings.conf
ADD mysql/update-mysql-password.sh /tmp/update-mysql-password.sh
RUN /bin/sh /tmp/update-mysql-password.sh

# Prepare installation of postfix
RUN echo "postfix postfix/root_address    string" | debconf-set-selections
RUN echo "postfix postfix/procmail        boolean false" | debconf-set-selections
RUN echo "postfix postfix/rfc1035_violation       boolean false" | debconf-set-selections
RUN echo "postfix postfix/bad_recipient_delimiter error" | debconf-set-selections
RUN echo "postfix postfix/protocols       select  all" | debconf-set-selections
RUN echo "postfix postfix/retry_upgrade_warning   boolean" | debconf-set-selections
RUN echo "postfix postfix/kernel_version_warning  boolean" | debconf-set-selections
RUN echo "postfix postfix/mailname        string  diva.vimm.be" | debconf-set-selections
RUN echo "postfix postfix/tlsmgr_upgrade_warning  boolean" | debconf-set-selections
RUN echo "postfix postfix/mydomain_warning        boolean" | debconf-set-selections
RUN echo "postfix postfix/recipient_delim string  +" | debconf-set-selections
RUN echo "postfix postfix/mynetworks      string  127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 172.17.0.0/16 " | debconf-set-selections
RUN echo "postfix postfix/not_configured  error" | debconf-set-selections
RUN echo "postfix postfix/main_mailer_type        select  Internet Site" | debconf-set-selections
RUN echo "postfix postfix/sqlite_warning  boolean" | debconf-set-selections
RUN echo "postfix postfix/destinations    string  diva.vimm.be, localhost.localdomain, localhost" | debconf-set-selections
RUN echo "postfix postfix/chattr  boolean false" | debconf-set-selections
RUN echo "postfix postfix/mailbox_limit   string  0" | debconf-set-selections
RUN echo "postfix postfix/relayhost       string" | debconf-set-selections
# Install postfix
RUN apt-get install -y postfix postfix-mysql
# Stop postfix
RUN service postfix stop

# Add postfix configuration files
ADD postfix/main.cf /etc/postfix/main.cf
ADD postfix/master.cf /etc/postfix/master.cf
RUN mkdir /etc/postfix/mysql
ADD postfix/mysql/virtual_alias_maps.cf /etc/postfix/mysql/virtual_alias_maps.cf
ADD postfix/mysql/virtual_domains_maps.cf /etc/postfix/mysql/virtual_domains_maps.cf
ADD postfix/mysql/virtual_mailbox_maps.cf /etc/postfix/mysql/virtual_mailbox_maps.cf

# Configure dovecot
#RUN mkdir -p /var/mail/vhosts/
#VOLUME /var/mail/vhosts
RUN groupadd -g 5000 vmail
RUN useradd -g vmail -u 5000 vmail -d /var/mail

# Add dovecot configuration files
ADD dovecot/dovecot.conf /etc/dovecot/dovecot.conf
ADD dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext
ADD dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
ADD dovecot/conf.d/10-logging.conf /etc/dovecot/conf.d/10-logging.conf
ADD dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
ADD dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf
RUN chown -R vmail:dovecot /etc/dovecot
RUN chmod -R o-rwx /etc/dovecot

# Configure Nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Configure PHP5-FPM
RUN sed -i -e "s/short_open_tag = Off/short_open_tag = On/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size = 8M/post_max_size = 20M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php5/fpm/php.ini
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "max_input_vars = 10000;" >> /etc/php5/fpm/php.ini
RUN echo "date.timezone = Europe/London;" >> etc/php5/fpm/php.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Prepare Nginx
RUN rm /etc/nginx/sites-enabled/default
ADD nginx/vimbadmin /etc/nginx/sites-available/vimbadmin
RUN ln -sf /etc/nginx/sites-available/vimbadmin /etc/nginx/sites-enabled/vimbadmin
RUN mkdir /var/www
ADD nginx/correct-vimbadmin-hostname.sh /tmp/correct-vimbadmin-hostname.sh
RUN /bin/sh /tmp/correct-vimbadmin-hostname.sh

# Configure ViMbAdmin
RUN mkdir /var/www/vimbadmin
RUN export INSTALL_PATH=/var/www/vimbadmin
RUN composer config -g github-protocols https
RUN composer create-project --no-interaction opensolutions/vimbadmin /var/www/vimbadmin -s dev
RUN chown -R www-data: /var/www/vimbadmin/var
ADD mysql/create-vimbadmin-database.sh /tmp/create-vimbadmin-database.sh
RUN /bin/sh /tmp/create-vimbadmin-database.sh
RUN cp /var/www/vimbadmin/application/configs/application.ini.dist /var/www/vimbadmin/application/configs/application.ini
ADD nginx/correct-vimbadmin-settings-file.sh /tmp/correct-vimbadmin-settings-file.sh
RUN /bin/sh /tmp/correct-vimbadmin-settings-file.sh
RUN cp /var/www/vimbadmin/public/.htaccess.dist /var/www/vimbadmin/public/.htaccess

# Create SQL tables for ViMbAdmin
ADD nginx/create-vimbadmin-sql-tables.sh /tmp/create-vimbadmin-sql-tables.sh
RUN /bin/sh /tmp/create-vimbadmin-sql-tables.sh

# Adjust web server file permissions
RUN chown -R www-data:root /var/www

# Clean up apt-get
RUN apt-get -y -q autoclean && apt-get -y -q autoremove && apt-get clean
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Expose MySQL, postfix and Nginx
EXPOSE 3306 25 80

# Copy supervisor config
ADD supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Correct permissions
RUN chown -R root:root /etc/postfix/ /etc/dovecot/ /etc/nginx/ /etc/supervisor/

# Start supervisor
CMD ["/usr/bin/supervisord"]
