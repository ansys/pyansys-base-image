FROM jupyter/base-notebook:python-3.8.6

MAINTAINER Alex Kaszynski "alexander.kaszynski@ansys.com"

USER root

RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get install  -yq --no-install-recommends \
    libgl1-mesa-glx \
    libglu1-mesa \
    libsm6 \
    xvfb \
    libopengl0 \
    libegl1 \
    software-properties-common \
    keyboard-configuration \
    kmod \
    libglvnd-dev \
    pkg-config \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER jovyan

# setup the itkwidgets conda enviornment
RUN conda update -n base conda
COPY environment.yml labextensions.txt /tmp/
RUN conda env update --name base --file /tmp/environment.yml
RUN conda run conda install -y nodejs
RUN conda run jupyter labextension install $(cat /tmp/labextensions.txt)

# machine learning and additional plotting
RUN pip install gym==0.17.3 \
                tensorflow==2.3.1 \
                numpy==1.18.5 \
                itk-meshtopolydata==0.6.2 \
                ipycanvas==0.6.0

# NVIDIA...
USER root
COPY NVIDIA-Linux-x86_64-450.51.06.run nvidia_drivers.run
RUN ./nvidia_drivers.run -s --no-kernel-module \
    && rm nvidia_drivers.run

# plotting and EGL VTK
COPY vtk-egl-9.0.1-cp38-cp38-linux_x86_64.whl vtk-egl-9.0.1-cp38-cp38-linux_x86_64.whl
RUN pip install vtk-egl-9.0.1-cp38-cp38-linux_x86_64.whl \
    && rm vtk-egl-9.0.1-cp38-cp38-linux_x86_64.whl \
    && pip install pyvista==0.27.2 ipyvtk-simple==0.1.3

# make jovyan sudo
RUN usermod -aG sudo jovyan
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER jovyan