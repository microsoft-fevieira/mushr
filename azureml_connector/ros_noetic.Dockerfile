FROM mcr.microsoft.com/azureml/openmpi4.1.0-ubuntu20.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    wget \
    terminator \
    curl \
    rsync \
    xvfb && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/*

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt update
RUN apt install -y ros-noetic-desktop-full
RUN apt install -y build-essential
RUN apt install -y git-all

RUN conda install -y conda=4.7.12 python=3.7 && conda clean -ay
RUN pip install --no-cache-dir azureml-core==1.35.0 --ignore-installed ruamel.yaml
RUN pip install --no-cache-dir azureml-defaults==1.35.0 --ignore-installed ruamel.yaml
RUN pip install --no-cache-dir rosdep
RUN pip install --no-cache-dir rosinstall
RUN pip install --no-cache-dir rosinstall-generator
RUN pip install --no-cache-dir wstool
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir networkx
RUN pip install --no-cache-dir sklearn
RUN pip install --no-cache-dir Cython
RUN pip install --no-cache-dir future
RUN pip install --no-cache-dir torch
RUN pip install --no-cache-dir empy
RUN pip install --no-cache-dir vcstool
RUN pip install --no-cache-dir setproctitle
RUN pip install --no-cache-dir defusedxml
RUN pip install --no-cache-dir pycryptodome


RUN conda install -y -c conda-forge x264='1!152.20180717' ffmpeg=4.0.2
RUN conda install -c anaconda opencv
RUN conda install tk

RUN rosdep init
RUN rosdep update

RUN apt install -y ros-noetic-ackermann-msgs \
    ros-noetic-map-server \  
    ros-noetic-urg-node \
    ros-noetic-robot-state-publisher
