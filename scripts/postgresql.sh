#!/usr/bin/env sh

set -e

# Define the date
DATE=$(date +%Y%m%d-%H-%M)

# Create backup directories if they don't exist
mkdir -p /tmp/"$POSTGRESQL_BACKUP_DIR"
cd /tmp/"$POSTGRESQL_BACKUP_DIR"

# Performing backup
if [ "$BACKUP_ALL" = "true" ]; then
  pg_dumpall \
    --dbname="$POSTGRESQL_DB_NAME" \
    --host="$POSTGRESQL_SERVICE_NAME" \
    --port="$POSTGRESQL_SERVICE_PORT" \
    --username="$POSTGRESQL_USERNAME" \
    --no-password \
    --file="/tmp/$POSTGRESQL_BACKUP_DIR/postgresql-all-$DATE.sql"

  tar -cvf "/tmp/$POSTGRESQL_BACKUP_DIR/postgresql-all-$DATE.tar" \
    "/tmp/$POSTGRESQL_BACKUP_DIR/postgresql-all-$DATE.sql"
else
  pg_dump \
    --dbname="$POSTGRESQL_DB_NAME" \
    --host="$POSTGRESQL_SERVICE_NAME" \
    --port="$POSTGRESQL_SERVICE_PORT" \
    --username="$POSTGRESQL_USERNAME" \
    --no-password \
    --file="/tmp/$POSTGRESQL_BACKUP_DIR/postgresql-$DATE.sql"

  tar -cvf "/tmp/$POSTGRESQL_BACKUP_DIR/postgresql-$DATE.tar" \
    "/tmp/$POSTGRESQL_BACKUP_DIR/postgresql-$DATE.sql"
fi

# Archiving the backup directory and copying the backup to persistent volume
cp "/tmp/$POSTGRESQL_BACKUP_DIR/postgresql-$DATE.tar" "$VOLUME_DIR"

# Send the backup to external backup server if needed 
if [ "$REMOTE_BACKUP" = "ssh" ]; then
  scp -o StrictHostKeyChecking=no -P "$REMOTE_SERVER_PORT" -i "$KEY_PATH" \
    "/tmp/$POSTGRESQL_BACKUP_DIR/postgresql-$DATE.tar" \
    "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
elif [ "$REMOTE_BACKUP" = "s3" ]; then
  aws s3 cp "/tmp/$POSTGRESQL_BACKUP_DIR/postgresql-$DATE.tar" \
    "s3://$BUCKET_NAME/"
else
  echo "Remote backup not specified."
fi

# Delete the temp directory
rm -rf "/tmp/$POSTGRESQL_BACKUP_DIR"

# Clean up old backups
find "$VOLUME_DIR" -type f -name "postgresql-*.tar" -mtime +$BACKUP_TIME -delete
