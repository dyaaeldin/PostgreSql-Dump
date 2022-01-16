#  PostgreSql Dump Image
* Dump postgresql database according periodically.
* Optionally you can send backups to remote server (ssh server or upload to s3)
* You can specify max no of backups on the local volume (for example you can keep only last 7 days on local volume)

### Upload backup to s3
1. Set REMOTE_BACKUP env "s3"
2. Set the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
3. Set the BUCKET_NAME.

### Copy the backup to remote ssh server
1. Set REMOTE_BACKUP env "ssh"
2. Set the REMOTE_HOST, REMOTE_DIR, REMOTE_SERVER_PORT and REMOTE_USER

### Backup all the databases using "pg_dumpall"
1. set the BACKUP_ALL env "true"

### Copy the backup to local volume directory
1. Edit the VOLUME_DIR to the path of the directory

### Set the pattern of the cronjob
1. Edit POSTGRESQL_CRON_PATTERN.


## Usage
### Docker-compose 
1. Update the docker-compose.yaml env variables to be suitable for usage
2. Run docker-compose up

`docker-compose up -d`

### kubernetes
1. Apply configmap (contain backup-script)

`kubectl create -f k8s-cronjob.yml`

2. Apply pvc - pv

`kubectl create -f k8s-pvc-pv.yaml`

3. Apply kubernetes cronjob

`kubectl create -f k8s-backup-cronjob.yml`

## HELM

still working on it
