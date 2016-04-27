#FROM ubuntu:14.04
FROM thomasredstone/base:1.0.1
MAINTAINER thomas@redstone.me.uk
ENV CACHED_FLAG 1

# Install nginx and php-fpm
RUN apt-get update -qq && apt-get -y upgrade
RUN apt-get install -y wget
RUN wget -qO - http://nginx.org/keys/nginx_signing.key | apt-key add - && \
echo -e "deb http://nginx.org/packages/mainline/ubuntu/ wily nginx\ndeb-src http://nginx.org/packages/mainline/ubuntu/ wily nginx" \
apt-get update -qq
RUN apt-get -y -qq install nginx
RUN usermod -u 1000 www-data
VOLUME /var/www/app
VOLUME /var/www/management

ADD nginx.crt /etc/nginx/nginx.crt
ADD nginx.key /etc/nginx/nginx.key
# Adding the configuration files
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/default.conf /etc/nginx/conf.d/

# Expose the port 80
EXPOSE 80

# Run nginx
ENTRYPOINT [ "/usr/sbin/nginx" ]
