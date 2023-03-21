#!/usr/bin/env sh

# Add cron job to run the PostgreSQL backup script
echo "$POSTGRESQL_CRON_PATTERN /usr/local/bin/postgresql.sh" >> /etc/crontabs/root 

# Ensure the backup script is executable
chmod a+x /usr/local/bin/postgresql.sh

# Start the crond service and run it in the foreground
crond -f
