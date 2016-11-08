#!/bin/bash

# Set the dockerhost host so that applications can communicate with each other
# via shared host ports on the docker host machine.
echo "`/sbin/ip route|awk '/default/ { print  $3}'` dockerhost" >> /etc/hosts

# Setup and start the Apache+PHP application
source /etc/apache2/envvars
exec apache2 -D FOREGROUND