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
   # Recreate daloradius tables on radius DB
   # We assume that radius DB does exists
   mysql -h $SQLHOST -u $SQLUSER -p$SQLPASS radius < /var/www/daloradius/contrib/db/mysql-daloradius.sql
   #Change mysql engine on radius DB to NDBCLUSTER
   /opt/mysql_change_engine_to_db.sh
else echo DB tables NO recreated;
fi

sed -ibak -e "s/\$configValues\['CONFIG_DB_HOST'\] = 'localhost';/\
\$configValues\['CONFIG_DB_HOST'\] = '$SQLHOST';/" daloradius.conf.php

sed -ibak -e "s/\$configValues\['CONFIG_DB_USER'\] = 'root';/\
\$configValues\['CONFIG_DB_USER'\] = '$SQLUSER';/" daloradius.conf.php

sed -ibak -e "s/\$configValues\['CONFIG_DB_PASS'\] = '';/\
\$configValues\['CONFIG_DB_PASS'\] = '$SQLPASS';/" daloradius.conf.php
touch $FILE;
exit 0;
