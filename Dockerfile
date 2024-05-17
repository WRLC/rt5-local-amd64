FROM ubuntu:24.04

# Install Apache
RUN apt update \
    && apt -y install apache2 libapache2-mod-fcgid apache2-dev

# Install Perl and other dependencies
RUN apt update \
    && apt -y install autoconf build-essential cpanminus curl libexpat-dev libgd-dev libssl-dev libz-dev gnupg \
    graphviz multiwatch openssl perl w3m libmemcached-dev apache2-dev

# Install MariaDB libraries
RUN apt update \
    && apt -y install libmariadb-dev libmariadb-dev-compat

# Install Perl modules
RUN apt update \
    && apt -y install libapache-session-wrapper-perl libbusiness-hours-perl libcgi-application-perl \
    libcgi-emulate-psgi-perl libcgi-psgi-perl libcss-minifier-xs-perl libcss-squish-perl libconvert-color-perl \
    libcrypt-eksblowfish-perl libdata-guid-perl libdata-ical-perl libdate-extract-perl libdate-manip-perl \
    libdatetime-format-natural-perl libdatetime-locale-perl libemail-address-list-perl libencode-detect-perl \
    libencode-hanextra-perl libdbix-searchbuilder-perl libdata-page-perl libdevel-globaldestruction-perl \
    libhtml-formattext-withlinks-andtables-perl libhtml-formatexternal-perl libhtml-gumbo-perl \
    libhtml-mason-psgihandler-perl libhtml-quoted-perl libhtml-rewriteattributes-perl libhtml-scrubber-perl \
    libipc-run3-perl libjson-perl libjavascript-minifier-xs-perl liblocale-maketext-fuzzy-perl \
    liblocale-maketext-lexicon-perl liblog-dispatch-perl libmime-tools-perl libmodule-path-perl libmodule-refresh-perl \
    libmodule-versions-report-perl libmoosex-nonmoose-perl libmoosex-role-parameterized-perl libmozilla-ca-perl \
    libnet-cidr-perl libnet-ip-perl libparallel-forkmanager-perl libpath-dispatcher-perl libpath-dispatcher-perl \
    starlet libregexp-common-net-cidr-perl libregexp-ipv6-perl librole-basic-perl libscope-upper-perl \
    libsymbol-global-name-perl libterm-readkey-perl libtext-password-pronounceable-perl libtext-quoted-perl \
    libtext-wikiformat-perl libtext-worddiff-perl libtext-wrapper-perl libtime-parsedate-perl libtree-simple-perl \
    libweb-machine-perl libxml-rss-perl libnet-ldap-perl libgd-graph-perl libgd-text-perl libfile-which-perl \
    libgnupg-interface-perl libperlio-eol-perl libdbd-mysql-perl libgraphviz2-perl libcrypt-x509-perl

# Install PHP
RUN apt update \
    && apt -y install php libapache2-mod-php

# Set up Apache
RUN a2dismod mpm_event \
    && a2dismod mpm_worker \
    && a2enmod mpm_prefork

# Add authmemcookie module
ADD https://github.com/ZenProjects/Apache-Authmemcookie-Module/archive/refs/tags/v2.0.1.tar.gz /tmp/v2.0.1.tar.gz
RUN tar -xzf /tmp/v2.0.1.tar.gz -C /tmp \
    && cd /tmp/Apache-Authmemcookie-Module-2.0.1 \
    && ./configure --with-apxs=/usr/bin/apxs --with-libmemcached=/usr \
    && make \
    && make install \
    && echo "LoadModule mod_auth_memcookie_module /usr/lib/apache2/modules/mod_auth_memcookie.so" > /etc/apache2/mods-available/mod_auth_memcookie.load \
    && a2enmod mod_auth_memcookie

# Set up RT user
RUN groupadd --system rt \
    && useradd --system --home-dir=/opt/rt5/var --gid=rt rt

# Install RT
RUN cd /tmp \
    && curl -O https://download.bestpractical.com/pub/rt/release/rt-5.0.5.tar.gz \
    && tar -xzf /tmp/rt-5.0.5.tar.gz -C /tmp \
    && cd /tmp/rt-5.0.5 \
    && PERL="/usr/bin/env -S perl -I/opt/rt5/local/lib/perl5" ./configure --prefix=/opt/rt5 --with-db-type=mysql  \
    --with-web-user=www-data --with-web-group=www-data --with-attachment-store=disk --enable-externalauth  \
    --enable-gd --enable-graphviz --enable-gpg --enable-smime \
    && make dirs \
    && make install \
    && mkdir -p /opt/rt5/var/data/RT-Shredder \
    && mkdir -p /opt/rt5/local/lib/RT/Interface \
    && chown -R www-data:www-data /opt/rt5

EXPOSE 80

# Start Apache
CMD apachectl -D FOREGROUND
