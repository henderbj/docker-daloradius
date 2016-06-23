From ubuntu:trusty
MAINTAINER Henderb Rodriguez

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Upgrade base system packages
RUN apt-get update && apt-get -y install software-properties-common \
    && add-apt-repository ppa:freeradius/stable \
    && apt-get update \
    && apt-get -y install freeradius freeradius-mysql
RUN apt-get -y install mysql-client-5.6
RUN apt-get -y install  apache2
RUN apt-get install -y php5-common php5-gd php-pear php-db libapache2-mod-php5 php-mail php-mail-mime
RUN apt-get install -y php5-mysql 
#If you need mysql server installed, then uncomment next line
#RUN apt-get install mysql-server-5.0

RUN apt-get install -y wget
WORKDIR /var/www
ENV DVER 0.9-9
RUN wget http://downloads.sourceforge.net/project/daloradius/daloradius/daloradius$DVER/daloradius-$DVER.tar.gz
RUN tar -zxvf daloradius-$DVER.tar.gz && rm daloradius-$DVER.tar.gz
RUN ln -s /var/www/daloradius-$DVER/ /var/www/daloradius
RUN chown www-data:www-data /var/www/daloradius* -R
RUN chmod 644 /var/www/daloradius/library/daloradius.conf.php

COPY install.sh mysql_change_engine.sh /opt/
RUN chown root:root /opt/*.sh && chmod u+x /opt/*.sh;

RUN mv /etc/apache2/apache2.conf /etc/apache2/apache2.conf.dist && \
    rm /etc/apache2/conf-enabled/* /etc/apache2/sites-enabled/*
COPY apache2.conf /etc/apache2/apache2.conf
COPY apache2-foreground /usr/local/bin/
RUN chown root:root /usr/local/bin/apache2-foreground && chmod u+x /usr/local/bin/apache2-foreground
EXPOSE 80 443

# Run
CMD /opt/install.sh;apache2-foreground;

