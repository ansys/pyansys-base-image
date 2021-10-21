FROM jupyter/base-notebook:hub-1.4.2

MAINTAINER PyAnsys Maintainers "pyansys.maintainers@ansys.com"

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

# initial setup enviornment to install jupyterlab
RUN conda update -n base conda
RUN conda install mamba -n base -c conda-forge

# install extensions
COPY environment.yml labextensions.txt /tmp/
RUN mamba env update -n base --file /tmp/environment.yml
RUN conda run jupyter labextension install $(cat /tmp/labextensions.txt)

# make jovyan sudo
USER root
RUN echo 'export PATH="/opt/conda/bin:$PATH"' >> /etc/profile
RUN usermod -aG sudo jovyan
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER jovyan
