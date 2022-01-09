#!/usr/bin/env sh

# Create backup directories if not exists
for dir in mnt tmp; do 
  if [ ! -d "/$dir/$POSTGRESQL_BACKUP_DIR" ]; then
     mkdir /$dir/$POSTGRESQL_BACKUP_DIR 
  fi
done

# Performing backup
PGPASSWORD="$POSTGRESQL_PASSWORD" pg_dump -h $POSTGRESQL_SERVICE_NAME \
        -p $POSTGRESQL_SERVICE_PORT -U $POSTGRESQL_USERNAME $POSTGRESQL_DB_NAME --clean \
        > /tmp/"$POSTGRESQL_BACKUP_DIR"/postgresql-$(date +%Y%m%d).sql

# Archicing the backup directory and copying the backup to persistent volume
cd /tmp && tar cvf postgresql-$(date +%Y%m%d-%H-%M).tar "$POSTGRESQL_BACKUP_DIR"
cp postgresql-*.tar /mnt/$POSTGRESQL_BACKUP_DIR/

# Send the backup to external backup server if needed 
if [ "$REMOTE_BACKUP" = "true" ]; then
        scp -o StrictHostKeyChecking=no -P $REMOTE_SERVER_PORT -i $KEY_PATH /tmp/postgresql-*.tar \
        $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
fi

# Delete the temp directory
rm -rf postgresql-*.tar /tmp/"$POSTGRESQL_BACKUP_DIR"/

# Cleanup the old backup
find /mnt -mindepth 1 -mtime +$BACKUP_TIME -delete
