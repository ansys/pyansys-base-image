#!/bin/bash

set -e

# build the ansys-base image single user image and pushes it to azure
source IMAGE_NAME
docker build -t $IMAGE .
docker push $IMAGE
