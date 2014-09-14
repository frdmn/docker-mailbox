FROM stackbrew/busybox:latest
MAINTAINER Jonas Friedmann <j@frd.mn>

# Set mount points
VOLUME ["/etc/postfix", "/var/mail", "/etc/dovecot", "/etc/mysql", "/var/lib/mysql", "/etc/nginx", "/var/www"]

# Return true
CMD ["true"]