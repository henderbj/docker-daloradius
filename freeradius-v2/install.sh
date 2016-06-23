#!/bin/bash

FILE=/root/daloradius-initialized;

if [ -f $FILE ];
then
   echo Already initialized
   exit 0; #already initialized. Avoid recreate database
fi

#echo These env variables must exist:
#echo -e "SQLHOST=$SQLHOST\nSQLUSER=$SQLUSER\nSQLPASS=$SQLPASS"

if [ $RECREATE_TABLES == "Yes" ];
then
   # Recreate tables on radius DB
   # We assume that radius DB does exists
   schema=/var/www/daloradius/contrib/db/fr2-mysql-daloradius-and-freeradius.sql
   mysql -h$SQLHOST -u$SQLUSER -p$SQLPASS radius < $schema
   #Change mysql engine on radius DB to NDBCLUSTER
   /opt/mysql_change_engine.sh
else echo DB tables NO recreated;
fi

daloconf=/var/www/daloradius-0.9-9/library/daloradius.conf.php
sed -ibak -e "s/\$configValues\['CONFIG_DB_HOST'\] = 'localhost';/\
\$configValues\['CONFIG_DB_HOST'\] = '$SQLHOST';/" $daloconf

sed -ibak -e "s/\$configValues\['CONFIG_DB_USER'\] = 'root';/\
\$configValues\['CONFIG_DB_USER'\] = '$SQLUSER';/" $daloconf

sed -ibak -e "s/\$configValues\['CONFIG_DB_PASS'\] = '';/\
\$configValues\['CONFIG_DB_PASS'\] = '$SQLPASS';/" $daloconf