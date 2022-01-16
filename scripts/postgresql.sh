#!/usr/bin/env sh

# Define the date
DATE=$(date +%Y%m%d-%H-%M)
# Create backup directories if not exists
[ -d /tmp/$POSTGRESQL_BACKUP_DIR ] || mkdir /tmp/$POSTGRESQL_BACKUP_DIR
cd /tmp/"$POSTGRESQL_BACKUP_DIR"

# Performing backup
if [ "$BACKUP_ALL" = "true" ]; then
    PGPASSWORD="$POSTGRESQL_PASSWORD" pg_dumpall -h $POSTGRESQL_SERVICE_NAME \
    -p $POSTGRESQL_SERVICE_PORT -U $POSTGRESQL_USERNAME \
    > /tmp/"$POSTGRESQL_BACKUP_DIR"/postgresql-all-$DATE.sql
    tar cvf postgresql-all-$DATE.tar postgresql-all-$DATE.sql
else
    PGPASSWORD="$POSTGRESQL_PASSWORD" pg_dump -h $POSTGRESQL_SERVICE_NAME \
    -p $POSTGRESQL_SERVICE_PORT -U $POSTGRESQL_USERNAME $POSTGRESQL_DB_NAME \
    > /tmp/"$POSTGRESQL_BACKUP_DIR"/postgresql-$DATE.sql
    tar cvf postgresql-$DATE.tar postgresql-$DATE.sql
fi

# Archicing the backup directory and copying the backup to persistent volume

cp postgresql-*.tar $VOLUME_DIR

# Send the backup to external backup server if needed 
if [ "$REMOTE_BACKUP" = "ssh" ]; then
    scp -o StrictHostKeyChecking=no -P $REMOTE_SERVER_PORT -i $KEY_PATH postgresql-*.tar \
    $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
elif [ "$REMOTE_BACKUP" = "s3" ]; then
    aws s3 cp postgresql-*.tar s3://$BUCKET_NAME/
else 
    echo "remote backup not specified"    
fi

# Delete the temp directory
rm -rf /tmp/"$POSTGRESQL_BACKUP_DIR"/

# Cleanup the old backup
find $VOLUME_DIR -mindepth 1 -mtime +$BACKUP_TIME -delete
