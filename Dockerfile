FROM jupyter/base-notebook:python-3.8.8

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

# initial setup enviornment to install jupyterlab
RUN conda update -n base conda
RUN conda install mamba -n base -c conda-forge

# install extensions
COPY environment.yml labextensions.txt /tmp/
RUN mamba env update -n base --file /tmp/environment.yml
RUN conda run jupyter labextension install $(cat /tmp/labextensions.txt)

COPY pyvista-0.29.1-py3-none-any.whl pyvista-0.29.1-py3-none-any.whl 
RUN pip install pyvista-0.29.1-py3-none-any.whl \
    && rm pyvista-0.29.1-py3-none-any.whl

# make jovyan sudo
USER root
RUN echo 'export PATH="/opt/conda/bin:$PATH"' >> /etc/profile
RUN usermod -aG sudo jovyan
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER jovyan
