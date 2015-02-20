#!/bin/sh

#CONFIGURATION
DESTINATION_DIR=/var/backups
TIMESTAMP_FORMAT='+%y-%m-%d.%s'
BACKUP_DIRS="/var/www"
BACKUP_MYSQL_DBS="mysql"
MYSQL_USER=root
MYSQL_PASS=enter_your_password
#CONFIGURATION END

TMP_DIR=`mktemp -d`

for dir in $BACKUP_DIRS; do
        cp --parents -r "$dir" $TMP_DIR
done

for db_name in $BACKUP_MYSQL_DBS; do
        mysqldump -u $MYSQL_USER -p$MYSQL_PASS $db_name > $TMP_DIR/$db_name.sql
done

tar -C $TMP_DIR -zcf $DESTINATION_DIR/`date $TIMESTAMP_FORMAT`.tar.gz .
rm -r $TMP_DIR

exit 0