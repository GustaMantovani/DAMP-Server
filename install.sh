#!/bin/bash

docker compose up -d
docker exec -it web-server bash -c 'apt install -y php libapache2-mod-php php-mysql && exit' && docker restart web-server
message="\nDB Server IP:"
echo -e "$message"
docker exec -it db-server bash -c 'ifconfig'
