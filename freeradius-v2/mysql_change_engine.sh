#!/bin/bash

DBNAME=radius
ENGINE=NDBCLUSTER
for t in `echo "show tables" | mysql -h$SQLHOST -u$SQLUSER -p$SQLPASS --batch --skip-column-names $DBNAME`; do
    echo Running \'mysql -h{hidden} -u{hidden} -p{hidden} $DBNAME -e "ALTER TABLE \`$t\` ENGINE = $ENGINE;"\';
    mysql -h$SQLHOST -u$SQLUSER -p$SQLPASS $DBNAME -e "ALTER TABLE \`$t\` ENGINE = $ENGINE;";
done
