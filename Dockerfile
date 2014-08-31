FROM ubuntu:12.04

ENV DEBIAN_FRONTEND noninteractive

MAINTAINER Jonas Friedmann version: 0.1

RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

RUN apt-get update

RUN apt-get -y -q autoclean
RUN apt-get -y -q autoremove
RUN apt-get clean

RUN apt-get install -y debconf-utils openssl rsyslog

# Install supervisor
RUN apt-get install -y supervisor

# Copy supervisor config
ADD supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start supervisor
CMD ["/usr/bin/supervisord"]
#CMD ["bash"]