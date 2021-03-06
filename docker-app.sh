#!/bin/bash

# Check if we need to load secrets from S3 into the environment
if [[ -n "$SECRETS_FILE" ]]; then
  echo "---- Loading S3 secrets into environment from ${SECRETS_FILE} ----"
  eval $(aws s3 cp s3://${SECRETS_FILE} - --region ${AWS_DEFAULT_REGION} | sed 's/^/export /')
else
  echo "---- No secrets file specified, ignoring ----"
fi

# Output Version
if [[ -f "/var/www/html/version" ]]; then
  VERSION=$(cat /var/www/html/version)
  echo "---- VERSION: ${VERSION} ----"
fi

# Setup and start the Apache+PHP application
source /etc/apache2/envvars
exec apache2 -D FOREGROUND