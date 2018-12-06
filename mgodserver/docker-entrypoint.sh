#!/bin/bash
#set -e
mkdir -p /data/db /data/var/log/mongodb
chown -R mongodb:mongodb /data/db 
exec mongod --config /data/configdb/mongod.conf

