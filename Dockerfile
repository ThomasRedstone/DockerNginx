FROM ubuntu:14.04
#FROM thomasredstone/base:1.0.1
MAINTAINER thomas@redstone.me.uk
ENV CACHED_FLAG 1

# Install nginx and php-fpm
RUN apt-get update -qq && apt-get -y upgrade
RUN apt-get -y -qq install nginx
RUN usermod -u 1000 www-data
VOLUME /var/www/app
VOLUME /var/www/management

# Adding the configuration files
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/default.conf /etc/nginx/conf.d/

# Expose the port 80
EXPOSE 80

# Run nginx
ENTRYPOINT [ "/usr/sbin/nginx" ]
