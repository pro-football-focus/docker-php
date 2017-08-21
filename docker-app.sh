#!/bin/bash

# Setup and start the Apache+PHP application
source /etc/apache2/envvars
exec apache2 -D FOREGROUND