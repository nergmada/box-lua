FROM        phusion/baseimage:0.9.16
MAINTAINER  Vinh Nguyen <kurei@axcoto.com>

# https://github.com/phusion/baseimage-docker/issues/58
# Fix debconf: unable to initialize frontend: Dialog
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN touch /build.2

RUN         echo 'deb http://us.archive.ubuntu.com/ubuntu/ trusty universe' >> /etc/apt/sources.list
RUN         apt-get -y update
RUN         apt-get -y upgrade

# ---------------- #
#   Installation   #
# ---------------- #

RUN apt-get -y update --fix-missing

# Image Magick
RUN sudo apt-get install -y \
  build-essential checkinstall libx11-dev libxext-dev zlib1g-dev libpng12-dev libjpeg-dev libfreetype6-dev libxml2-dev --fix-missing

RUN sudo apt-get build-dep -y imagemagick
RUN sudo apt-get install -y curl wget

# WEBP format
RUN sudo apt-get install -y libwebp-dev devscripts

#RUN wget http://www.imagemagick.org/download/releases/ImageMagick-6.8.9-10.tar.bz2
RUN wget http://www.imagemagick.org/download/releases/ImageMagick-6.8.9-10.tar.xz
RUN tar xf ImageMagick-6.8.9-10.tar.xz
RUN cd ImageMagick-6.8.9-10 && ./configure --prefix=/usr --with-webp && make && make install

RUN sudo apt-get install -y tcpdump htop gdb

# Debug
RUN sudo apt-get install -y curl wget htop

# Build
RUN sudo apt-get install -y \
  wget build-essential autoconf automake pkg-config libssl-dev openssl libxslt-dev

# Lib RSVG
RUN apt-get install librsvg2-2
RUN apt-get install librsvg2-bin

# Lua
RUN sudo apt-get install -y luajit luarocks

# OpenResty
RUN sudo wget http://openresty.org/download/ngx_openresty-1.9.3.1.tar.gz
RUN tar -zxvf ngx_openresty-1.9.3.1.tar.gz
#RUN sudo wget https://github.com/openresty/ngx_openresty/archive/v1.9.3.1.tar.gz
#RUN tar -zxvf v1.9.3.1.tar.gz
RUN cd ngx_openresty-1.9.3.1 && ./configure --with-luajit --sbin-path=/usr/sbin/nginx  --conf-path=/etc/nginx/nginx.conf  --error-log-path=/var/log/nginx/error.log  --http-client-body-temp-path=/var/lib/nginx/body  --http-fastcgi-temp-path=/var/lib/nginx/fastcgi  --http-log-path=/var/log/nginx/access.log  --http-proxy-temp-path=/var/lib/nginx/proxy  --http-scgi-temp-path=/var/lib/nginx/scg --http-uwsgi-temp-path=/var/lib/nginx/uwsgi  --lock-path=/var/lock/nginx.lock      --pid-path=/var/run/nginx.pid  --with-http_gzip_static_module --with-http_realip_module  --with-http_stub_status_module  --with-http_ssl_module  --with-http_sub_module --with-sha1=/usr/include/openssl  --with-md5=/usr/include/openssl --with-debug && make && sudo make install

RUN mkdir -p /var/lib/nginx
RUN mkdir -p /nginx

RUN unlink /usr/bin/lua && sudo ln -s /usr/bin/luajit /usr/bin/lua

RUN sudo luarocks install luasocket --from=http://luarocks.logiceditor.com/rocks/
RUN sudo luarocks install magick   --from=http://luarocks.logiceditor.com/rocks/

RUN sudo apt-get install -y openssl
#RUN sudo luarocks install luassert --only-server=http://rocks.moonscript.org
RUN sudo luarocks install luasec --only-server=http://rocks.moonscript.org OPENSSL_LIBDIR=/usr/lib/x86_64-linux-gnu
RUN sudo luarocks install busted --only-server=http://rocks.moonscript.org
RUN which lua
RUN which lua
RUN which luajit
RUN which nginx

WORKDIR /etc/nginx/

RUN sudo wget https://github.com/pintsized/lua-resty-http/archive/v0.05.tar.gz && tar xvf v0.05.tar.gz

# ----------------- #
#   Clean up        #
# ----------------- #
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


