#!/bin/bash
docker start db-server web-server
docker exec -it db-server bash -c 'ifconfig'
