FROM thomasredstone/base:3.0.0
MAINTAINER thomas@redstone.me.uk
ENV CACHED_FLAG 1

# Install nginx and php-fpm
RUN apt-get update -qq && apt-get -y upgrade
RUN apt-get install -y build-essential zlib1g-dev libpcre3-dev unzip uuid-dev
RUN curl -f -L -sS https://ngxpagespeed.com/install --output ~/pagespeed-install && \
    sed -i 's/sudo //g' ~/pagespeed-install && \
    chmod +x ~/pagespeed-install && ~/pagespeed-install --nginx-version latest

RUN usermod -u 1000 www-data && mkdir /usr/local/nginx/conf/conf.d/
VOLUME /var/www/app
VOLUME /var/www/management

RUN openssl req -x509 -nodes -subj '/CN=example.com/O=TestCertCo./C=GB' -days 365 -newkey rsa:2048 -keyout /usr/local/nginx/nginx.key -out /usr/local/nginx/nginx.crt

# Adding the configuration files
ADD conf/nginx.conf /usr/local/nginx/conf/nginx.conf
ADD conf/default.conf /usr/local/nginx/conf/conf.d/

# Expose the port 80
EXPOSE 80

# Run nginx
ENTRYPOINT [ "/usr/local/nginx/sbin/nginx" ]
