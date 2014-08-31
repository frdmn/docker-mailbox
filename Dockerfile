FROM ubuntu:14.04
MAINTAINER Jonas Friedmann <j@frd.mn> version: 0.1
ENV DEBIAN_FRONTEND noninteractive

# Update locale
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

# Update apt
RUN apt-get update

# Install debconf-utils
RUN apt-get install -y debconf-utils

# Install MySQL
RUN apt-get install -y mysql-server-5.5
RUN sed -i -e "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
ADD mysql/update-mysql-password.sh /tmp/update-mysql-password.sh
RUN /bin/sh /tmp/update-mysql-password.sh

# Install SSH server
RUN apt-get install -y openssh-server
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
# Add configuration files
ADD postfix/main.cf /etc/postfix/main.cf
ADD postfix/master.cf /etc/postfix/master.cf

# Install supervisor
RUN apt-get install -y supervisor

# Copy supervisor config
ADD supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Clean up apt-get
RUN apt-get -y -q autoclean
RUN apt-get -y -q autoremove
RUN apt-get clean
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Expose SSH
EXPOSE 22
# Expost MySQL
EXPOSE 3306

# Start supervisor
CMD ["/usr/bin/supervisord"]
