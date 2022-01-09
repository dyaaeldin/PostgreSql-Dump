#!/usr/bin/env sh

# Configure daily cronjob
echo "$MONGODB_CRON_PATTERN /usr/local/bin/postgresql.sh" >> /etc/crontabs/root 
chmod a+x /usr/local/bin/postgresql.sh

# Start the crond service
crond -f 
