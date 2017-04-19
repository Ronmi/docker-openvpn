# Synopsis

```bash
# initialize CA and server certificates
docker-compose run --rm daemon tool.sh init

# generate client certificates
docker-compose run --rm daemon tool.sh gen johndoe

# start the service
docker-compose up -d
```
