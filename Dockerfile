FROM hyperknot/baseimage16:1.0.0

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TERM=xterm container=docker

# start
RUN \
    cd /tmp \
    && apt-get -o Acquire::GzipIndexes=false update \
    && apt-get update && apt-get -y upgrade \
    && apt-get -y install wget curl unzip nano vim rsync sudo tar git apt-transport-https gettext-base ca-certificates  \
        apt-utils software-properties-common build-essential openssl inotify-tools nginx letsencrypt \

    && rm -rf /tmp/* \
    && apt-get -yf autoremove \
    && apt-get clean 

ADD ./files /

# tweaks
RUN \
    cd /tmp \
    && mkdir -p /app-start/etc \
    && mkdir -p /app-start/var/log/app \
    && mkdir -p /app-start/var/www/html \

    && mv /etc/app   /app-start/etc/nginx \
    && rm -rf /etc/nginx \
    && ln -s /app/etc/nginx /etc/nginx \

    && mv /etc/letsencrypt   /app-start/etc/letsencrypt \
    && rm -rf /etc/letsencrypt \
    && ln -s /app/etc/letsencrypt /etc/letsencrypt \

    && mv /var/log/nginx   /app-start/var/log/nginx \
    && rm -rf /var/log/nginx \
    && ln -s /app/var/log/nginx /var/log/nginx \

    && mv /var/www/html   /app-start/var/www/html \
    && rm -rf /var/www/html \
    && ln -s /app/var/www/html /var/www/html \

    && rm -rf /tmp/*

VOLUME ["/app", "/backup"]

EXPOSE 22 80 443