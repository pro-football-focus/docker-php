#!/bin/bash -ex
APP_NAME=php

# Extract the application version from the mix file
VERSION=$(cat version)

# Push the built image to Docker Hub
docker push profootballfocus/${APP_NAME}:${VERSION}

