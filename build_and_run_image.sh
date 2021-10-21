#!/bin/bash

IMAGE="pyansys-base-image:dev"

# build the jupyter single user image
docker build -t "$IMAGE" .

# w/o GPU
docker run -it --rm \
       -v /home/$USER/python:/mnt/python \
       -v /tmp:/mnt/tmp \
       -v `pwd`/test_notebooks:/home/jovyan/test_notebooks \
       -p 8888:8888 "$IMAGE"
