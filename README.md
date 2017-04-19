# Synopsis

```bash
# initialize CA and server certificates
docker-compose run --rm daemon tool.sh init

# generate client certificates
docker-compose run --rm daemon tool.sh gen johndoe

# start the service
docker-compose up -d
```

# RaspberryPI and Linode support

Just use specially designed config file.

```bash
# run on rpi
docker-compose -f docker-compose.rpi.yml up -d

# run on linode
docker-compose -f docker-compose.linode.yml up -d
```
