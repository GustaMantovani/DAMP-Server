#!/bin/bash

docker compose up -d
message="\nDB Server IP:"
echo -e "$message"
docker exec -it db-server bash -c 'ifconfig'
