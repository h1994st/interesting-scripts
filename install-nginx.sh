#!/bin/bash

set -e;

function usage()
{
    echo "USAGE: "$0" <nginx version number>";
    echo "e.g. "$0" 1.9.12";
}

if [ $# != 1 ] ; then
    echo "Wrong arguments!";
    usage;
    exit 1;
fi

OPENSSL_SRC_DIR="openssl-1.0.2d"
ZLIB_SRC_DIR="zlib-1.2.8"
NGX_HTTP_FILTER_MODULE="ngx_http_substitutions_filter_module"
NGINX_SRC_DIR="nginx-"$1

# Dependencies
if [ ! -d $OPENSSL_SRC_DIR ] ; then
    echo "Downloading openssl source code..."
    wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2d.tar.gz && tar xf openssl-1.0.2d.tar.gz && rm openssl-1.0.2d.tar.gz || (echo "Error" && exit 1);
    echo "Done!"
fi

if [ ! -d $ZLIB_SRC_DIR ] ; then
    echo "Downloading zlib source code..."
    wget http://zlib.net/zlib-1.2.8.tar.gz && tar xf zlib-1.2.8.tar.gz && rm zlib-1.2.8.tar.gz || (echo "Error" && exit 1);
    echo "Done!"
fi

if [ ! -d $NGX_HTTP_FILTER_MODULE ] ; then
    echo "Downloading nginx http substitutions filter module source code..."
    git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module || (echo "Error" && exit 1);
    echo "Done!"
fi

# NGINX source code
if [ ! -d $NGINX_SRC_DIR ] ; then
    echo "Downloading nginx "$1" source code..."
    wget http://nginx.org/download/nginx-${1}.tar.gz && tar xzf nginx-${1}.tar.gz && rm nginx-${1}.tar.gz || (echo "Error" && exit 1);
    echo "Done!"
fi

echo "Entering "$NGINX_SRC_DIR;
cd $NGINX_SRC_DIR;

echo "";
echo "Configuring...";
./configure \
--with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' \
--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro' \
--sbin-path=/usr/sbin/nginx \
--prefix=/usr/share/nginx \
--conf-path=/etc/nginx/nginx.conf \
--http-log-path=/var/log/nginx/access.log \
--error-log-path=/var/log/nginx/error.log \
--lock-path=/var/lock/nginx.lock \
--pid-path=/run/nginx.pid \
--http-client-body-temp-path=/var/lib/nginx/body \
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-proxy-temp-path=/var/lib/nginx/proxy \
--http-scgi-temp-path=/var/lib/nginx/scgi \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
--with-debug \
--with-pcre-jit \
--with-ipv6 \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_dav_module \
--with-http_geoip_module \
--with-http_gzip_static_module \
--with-http_image_filter_module \
--with-http_v2_module \
--with-http_sub_module \
--with-http_xslt_module \
--with-mail \
--with-mail_ssl_module \
--with-http_sub_module \
--with-zlib=../$ZLIB_SRC_DIR \
--with-openssl=../$OPENSSL_SRC_DIR \
--add-module=../$NGX_HTTP_FILTER_MODULE || (echo "Configure error");
echo "Done!";

echo "";
echo "Compiling...";
make || (echo "Compile error");
echo "Done!";

echo "";
echo "Installing...";
sudo make install || (echo "Install error");
echo "Done!";
nginx -v;

sudo service nginx restart;

echo "Exit directory "$NGINX_SRC_DIR:
cd ..;
echo "Deleting nginx source code..."
rm -rf $NGINX_SRC_DIR;
echo "Done!";

