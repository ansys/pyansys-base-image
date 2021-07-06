#!/bin/bash

set -e

# build the jupyter single user image
source IMAGE_NAME
docker build -t $IMAGE .
