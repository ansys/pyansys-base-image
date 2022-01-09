FROM jupyter/base-notebook:hub-2.0.1

MAINTAINER PyAnsys Maintainers "pyansys.maintainers@ansys.com"

USER root

RUN apt-get update \
 && DEBIAN_FRONTEND="noninteractive" apt-get install -yq --no-install-recommends \
    libgl1-mesa-glx \
    libglu1-mesa \
    libsm6 \
    libopengl0 \
    libegl1 \
    software-properties-common \
    keyboard-configuration \
    kmod \
    libglvnd-dev \
    pkg-config \
    libosmesa6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER jovyan

# initial setup enviornment to install jupyterlab
RUN conda update -n base conda
RUN conda install mamba -n base -c conda-forge

# install enviornment
COPY environment.yml /tmp/
RUN mamba env update -n base --file /tmp/environment.yml

# override vtk with custom VTK with OSMesa
# don't uninstall VTK as cadquery depends on some of the libraries, but ignore it so we can keep then while getting the benefits for osmesa
RUN pip install https://github.com/pyvista/pyvista-wheels/raw/main/vtk-osmesa-9.1.0-cp39-cp39-linux_x86_64.whl --ignore-installed

# make jovyan sudo
USER root
RUN echo 'export PATH="/opt/conda/bin:$PATH"' >> /etc/profile
RUN usermod -aG sudo jovyan
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER jovyan
