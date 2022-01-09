#  PostgreSql Dump Image
* Dump postgresql database according periodically according to the pattern of the cronjob
* Optionally you can send backups to external storage
* You can specify max no of backups on the local volume
* Read the files carefuly to make sure that it suitable for your needs

## Usage
### Docker-compose 
1. Update docker-compose.yml env variables
2. Run docker-compose

`docker-compose up -d`

### kubernetes
1. Apply configmap (contain backup-script)

`kubectl create -f k8s-cronjob.yml`
2. Apply pvc - pv

`kubectl create -f k8s-pvc-pv.yaml`
3. Apply kubernetes cronjob

`kubectl create -f k8s-backup-cronjob.yml`
