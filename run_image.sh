source IMAGE_NAME

# with GPU
# docker run -it --rm -v /home/$USER/python:/mnt/python -v /tmp:/mnt/tmp -p 8888:8888 --gpus all $IMAGE

# w/o GPU
docker run -it --rm \
       -v /home/$USER/python:/mnt/python \
       -v /tmp:/mnt/tmp \
       -v `pwd`/test_notebooks:/home/jovyan/test_notebooks \
       -p 8888:8888 $IMAGE
