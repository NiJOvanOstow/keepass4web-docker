FROM ubuntu:16.04

ADD lixmal-ubuntu-keepass4web-xenial.list /etc/apt/sources.list.d/lixmal-ubuntu-keepass4web-xenial.list
ADD lixmal_ubuntu_keepass4web.gpg /etc/apt/trusted.gpg.d/lixmal_ubuntu_keepass4web.gpg
    
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    libapache2-mod-perl2 \
    libnet-ldap-perl \
    libdancer2-session-cookie-perl \
    libcrypt-eksblowfish-perl \
    keepass4web \
    && apt-get clean \
    && a2enmod ssl
    
EXPOSE 80
EXPOSE 443

VOLUME ["/conf"]

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

WORKDIR /conf

ADD defaults /defaults
ADD start.sh /start.sh
RUN chmod 755 /start.sh && \
    chown -R root:root /defaults && \
    rm -R /etc/keepass4web && \
    rm -R /etc/apache2/sites-enabled/000-default.conf && \
    rm /etc/apache2/sites-enabled/keepass4web.conf && \
    ln -s /conf/apache.conf /etc/apache2/sites-enabled/keepass4web.conf

STOPSIGNAL SIGTERM

CMD ["/start.sh"]