#FROM ubuntu:14.04
FROM thomasredstone/base:2.0.1
MAINTAINER thomas@redstone.me.uk
ENV CACHED_FLAG 1

# Install nginx and php-fpm
RUN apt-get update -qq && apt-get -y upgrade
RUN apt-get install -y wget openssl nginx
RUN usermod -u 1000 www-data
VOLUME /var/www/app
VOLUME /var/www/management

RUN openssl req -x509 -nodes -subj '/CN=example.com/O=TestCertCo./C=GB' -days 365 -newkey rsa:2048 -keyout /etc/nginx/nginx.key -out /etc/nginx/nginx.crt

# Adding the configuration files
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/default.conf /etc/nginx/conf.d/

# Expose the port 80
EXPOSE 80

# Run nginx
ENTRYPOINT [ "/usr/sbin/nginx" ]
