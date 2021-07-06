#!/bin/bash

set -e

# pushes base image to azure
source IMAGE_NAME
docker push $IMAGE
