FROM ubuntu:12.04

ENV DEBIAN_FRONTEND noninteractive

MAINTAINER Jonas Friedmann version: 0.1

RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

RUN apt-get update

RUN apt-get -y -q autoclean
RUN apt-get -y -q autoremove
RUN apt-get clean

RUN apt-get install -y python-setuptools debconf-utils openssl rsyslog

RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout
ADD ./supervisord.conf /etc/supervisord.conf
