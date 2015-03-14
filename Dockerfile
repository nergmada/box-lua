FROM        phusion/baseimage:0.9.16
MAINTAINER  Vinh Nguyen <kurei@axcoto.com>

# https://github.com/phusion/baseimage-docker/issues/58
# Fix debconf: unable to initialize frontend: Dialog
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN         echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list
RUN         apt-get -y update
RUN         apt-get -y upgrade


# ---------------- #
#   Installation   #
# ---------------- #

# Image Magick
RUN sudo apt-get install -y \
  imagemagick imagemagick-common libmagickcore-dev  libmagickcore5 libmagickcore5-extra  libmagickwand-dev libmagickwand5

RUN sudo apt-get install -y tcpdump htop

# Debug
RUN sudo apt-get install -y curl wget htop

# Build
RUN sudo apt-get install -y \
  wget build-essential autoconf automake pkg-config libssl-dev openssl libxslt-dev

# Lua
RUN sudo apt-get install -y luajit luarocks

# OpenResty
RUN sudo wget http://openresty.org/download/ngx_openresty-1.7.7.2.tar.gz
RUN tar -zxvf ngx_openresty-1.7.7.2.tar.gz
#RUN sudo wget https://github.com/openresty/ngx_openresty/archive/v1.7.7.2.tar.gz
#RUN tar -zxvf v1.7.7.2.tar.gz
RUN cd ngx_openresty-1.7.7.2 && ./configure --with-luajit --sbin-path=/usr/sbin/nginx  --conf-path=/etc/nginx/nginx.conf  --error-log-path=/var/log/nginx/error.log  --http-client-body-temp-path=/var/lib/nginx/body  --http-fastcgi-temp-path=/var/lib/nginx/fastcgi  --http-log-path=/var/log/nginx/access.log  --http-proxy-temp-path=/var/lib/nginx/proxy  --http-scgi-temp-path=/var/lib/nginx/scg --http-uwsgi-temp-path=/var/lib/nginx/uwsgi  --lock-path=/var/lock/nginx.lock      --pid-path=/var/run/nginx.pid  --with-http_gzip_static_module --with-http_realip_module  --with-http_stub_status_module  --with-http_ssl_module  --with-http_sub_module --with-sha1=/usr/include/openssl  --with-md5=/usr/include/openssl && make && sudo make install

RUN mkdir -p /var/lib/nginx
RUN mkdir -p /nginx

RUN unlink /usr/bin/lua && sudo ln -s /usr/bin/luajit /usr/bin/lua

RUN sudo luarocks install luasocket --from=http://luarocks.logiceditor.com/rocks/
RUN sudo luarocks install  magick   --from=http://luarocks.logiceditor.com/rocks/


# ----------------- #
#   Clean up        #
# ----------------- #
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /etc/nginx/

