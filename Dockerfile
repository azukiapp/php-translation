FROM azukiapp/ubuntu:trusty
MAINTAINER Azuki <support@azukiapp.com>

RUN echo "deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main" \
        > /etc/apt/sources.list.d/php5-5.6.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-key E5267A6C

# Install php5 + apache2 + DB clients
RUN apt-get update \
  && apt-get install -y nodejs --no-install-recommends \
  && apt-get -yq install \
      libxml2 \
      libcurl4-openssl-dev \
      subversion \
      php5-dev \
      php5-cli \
      php5-sqlite \
      php5-mcrypt \
      php5-curl \
      php5-json \
      php5-gd \
      php5-fpm \
      nginx \
      php-pear \
      sqlite3 libsqlite3-dev \
      unzip \
  && apt-get clean -qq \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# nginx config
RUN curl -L https://gist.github.com/darron/6159214/raw/30a60885df6f677bfe6f2ff46078629a8913d0bc/gistfile1.txt \
    -o /etc/nginx/sites-available/default \
  && echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini \
  && echo "daemon off;" >> /etc/nginx/nginx.conf

# Install phd
RUN git clone https://git.php.net/repository/phd.git \
  && cd phd \
  && sudo pear install package.xml package_generic.xml package_php.xml

# Install web-php-master
RUN curl -L https://github.com/php/web-php/archive/master.zip -o master.zip \
  && unzip master.zip \
  && rm -Rf /var/www/* \
  && rsync -avzC --timeout=600 --delete --delete-after --exclude='distributions/**' \
     --exclude='extra/**' --exclude='backend/notes/**' \
     -- ./web-php-master/ /var/www/ \
  && rm -Rf master.tar.gz web-php-master

EXPOSE 80
