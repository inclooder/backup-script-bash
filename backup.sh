#!/bin/sh
# vim: et sw=2 ts=2

set -eo pipefail

#CONFIGURATION
DESTINATION_DIR=/var/backups
TIMESTAMP_FORMAT='+%y-%m-%d.%s'
BACKUP_DIRS="/var/log"
BACKUP_MYSQL_DBS="mysql"
MYSQL_USER="root"
MYSQL_PASS="enter your password here"
#CONFIGURATION END

echo "Starting..."
TMP_DIR="$(mktemp -d)"
echo "Temp directory created in $TMP_DIR"

for dir in "$BACKUP_DIRS"; do
  echo "Creating backup for directory $dir"
  cp --parents -r "$dir" "$TMP_DIR"
done

for db_name in "$BACKUP_MYSQL_DBS"; do
  echo "Creating dump for database $db_name"
  mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASS" "$db_name" > "$TMP_DIR/$db_name.sql"
done

TAR_ARCHIVE="$DESTINATION_DIR/$(date $TIMESTAMP_FORMAT).tar.gz"
echo "Creating tar archive in $TAR_ARCHIVE"
tar -C "$TMP_DIR" -zcf "$TAR_ARCHIVE" .
rm -r "$TMP_DIR"
echo "Done!"
