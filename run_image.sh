source IMAGE_NAME
docker run -it --rm -v /home/alex/python:/mnt/python -v /tmp:/mnt/tmp -p 8888:8888 --gpus all $IMAGE
