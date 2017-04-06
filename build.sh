#!/bin/bash -ex
APP_NAME=php

# Extract the application version from the mix file
VERSION=$(cat version)

# Build the application image
docker build -t profootballfocus/${APP_NAME}:${VERSION} .
