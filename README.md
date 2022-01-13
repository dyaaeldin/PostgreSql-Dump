#  PostgreSql Dump Image
* Dump postgresql database according periodically.
* Optionally you can send backups to remote server (ssh server or upload to s3)
* You can specify max no of backups on the local volume (for example you can keep only last 7 days on local volume)
* 
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
