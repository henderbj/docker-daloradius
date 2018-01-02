#!/bin/bash

FILE=/root/radius-initialized;

if [ -f $FILE ];
then
   echo Already initialized
   exit 0; #already initialized. Avoid recreate database
fi

#echo These env variables must exist:
#echo -e "SQLHOST=$SQLHOST\nSQLUSER=$SQLUSER\nSQLPASS=$SQLPASS"

if [ "$CHANGE_ENGINES" == "Yes" ];
then
   #Change mysql engine on radius DB to NDBCLUSTER
   /opt/mysql_change_engine.sh
fi

if [ "$RECREATE_TABLES" == "Yes" ];
then
   # Recreate tables on radius DB
   # We assume that radius DB does exists
   ##schema=/var/www/daloradius/contrib/db/fr2-mysql-daloradius-and-freeradius.sql
   ##mysql -h$SQLHOST -u$SQLUSER -p$SQLPASS radius < $schema
   # Add serf_servers table
   mysql -h$SQLHOST -u$SQLUSER -p$SQLPASS radius < /opt/mysql-create-table-serf_servers.sql
else echo DB tables NO recreated;
fi

BASEDIR=/usr/local/etc/raddb
# Configure freeradius for MYSQL
ln -s $BASEDIR/mods-available/sql $BASEDIR/mods-enabled/sql
file=$BASEDIR/mods-enabled/sql
sed -i -e "s/\sdriver = \"rlm_sql_null\"/\tdriver = \"rlm_sql_mysql\"/" $file
sed -i -e "s/\sdialect = \"sqlite\"/\tdialect = \"mysql\"/" $file
sed -i -e "s/#\sserver = \"localhost\"/\tserver = \"$SQLHOST\"/" $file
sed -i -e "s/#\slogin = \"radius\"/\tlogin = \"$SQLUSER\"/" $file
sed -i -e "s/#\spassword = \"radpass\"/\tpassword = \"$SQLPASS\"/" $file
sed -i -e "s/#\sread_clients = yes/\tread_clients = yes/" $file
file=/usr/local/etc/raddb/sites-enabled/default
sed -i -e "s/#\ssql$/\tsql/" $file
sed -i -e "s/#\sreply_log$/\treply_log/" $file

# Configure radius for libssl
sed -i -e "s/\sallow_vulnerable_openssl = no/\tallow_vulnerable_openssl = 'CVE-2016-6304'/" $BASEDIR/radiusd.conf

touch /root/radius-initialized
