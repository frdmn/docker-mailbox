FROM ubuntu:12.04

ENV DEBIAN_FRONTEND noninteractive

MAINTAINER Jonas Friedmann version: 0.1

RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

RUN apt-get update

# Install debconf-utils
RUN apt-get install -y debconf-utils

# Install MySQL
RUN apt-get install -y mysql-server-5.5
RUN sed -i -e "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
ADD mysql/update-mysql-password.sh /tmp/update-mysql-password.sh
RUN /bin/sh /tmp/update-mysql-password.sh

# Install supervisor
RUN apt-get install -y supervisor

# Copy supervisor config
ADD supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set root password
RUN echo "root:root" | chpasswd

# Clean up apt-get
RUN apt-get -y -q autoclean
RUN apt-get -y -q autoremove
RUN apt-get clean

# Start supervisor
CMD ["/usr/bin/supervisord"]
#CMD ["bash"]