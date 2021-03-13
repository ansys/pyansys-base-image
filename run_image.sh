source IMAGE_NAME
docker run -it --rm -v /home/$USER/python:/mnt/python -v /tmp:/mnt/tmp -p 8888:8888 --gpus all $IMAGE
