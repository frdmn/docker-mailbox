FROM ubuntu:14.04
MAINTAINER Jonas Friedmann <j@frd.mn> version: 0.1
ENV DEBIAN_FRONTEND noninteractive

# Update locale
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

# Update apt
RUN apt-get update

# Install dependencies
RUN apt-get install -y debconf-utils mysql-server-5.5 openssh-server dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-mysql mysql-server dovecot-sieve dovecot-managesieved supervisor nginx

# Configure MySQL
RUN sed -i -e "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
ADD mysql/update-mysql-password.sh /tmp/update-mysql-password.sh
RUN /bin/sh /tmp/update-mysql-password.sh

# Configure SSH server
RUN mkdir /var/run/sshd
RUN echo "root:root" | chpasswd
RUN sed -i "s/session.*required.*pam_loginuid.so/#session    required     pam_loginuid.so/" /etc/pam.d/sshd
RUN sed -i "s/PermitRootLogin without-password/#PermitRootLogin without-password/" /etc/ssh/sshd_config

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

# Copy supervisor config
ADD supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Correct permissions
RUN chown -R root:root /etc/postfix/ /etc/dovecot/ /etc/nginx/ /etc/supervisor/

# Clean up apt-get
RUN apt-get -y -q autoclean && apt-get -y -q autoremove && apt-get clean
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Expose SSH, MySQL and postfix
EXPOSE 22 3306 25

# Start supervisor
CMD ["/usr/bin/supervisord"]
