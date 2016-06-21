From php:7.0.7-apache
MAINTAINER Henderb Rodriguez

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Upgrade base system packages
RUN apt-get update
RUN apt-get install -y apt-utils

RUN apt-get upgrade -y

### Start editing ###
RUN apt-get install -y php5-common php5-gd php-pear php-db libapache2-mod-php5 php-mail php-mail-mime
RUN apt-get install -y php5-mysql 
RUN apt-get install -y wget
WORKDIR /root
ENV DVER 0.9-9
RUN wget http://downloads.sourceforge.net/project/daloradius/daloradius/daloradius$DVER/daloradius-$DVER.tar.gz
RUN tar -zxvf daloradius-$DVER.tar.gz
RUN cp daloradius-$DVER/ /var/www -R
RUN ln -s /var/www/daloradius-$DVER/ /var/www/daloradius
RUN chown www-data:www-data /var/www/daloradius* -R
RUN chmod 644 /var/www/daloradius/library/daloradius.conf.php
WORKDIR /var/www/daloradius/library
RUN apt-get install -y mysql-client
RUN apt-get install -y vim

# Add files
ADD mysql_change_engine_to_db.sh /opt/mysql_change_engine_to_db.sh
ADD install.sh /opt/install.sh
RUN chown root:root /opt/*.sh && chmod u+x /opt/*.sh;

# Run
CMD /opt/install.sh;apache2-foreground;
