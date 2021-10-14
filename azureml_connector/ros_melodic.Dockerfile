FROM mcr.microsoft.com/azureml/openmpi3.1.2-ubuntu18.04:20200423.v1

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ROS_DISTRO melodic

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-ros-core=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    rsync \
    xvfb \
    nano \ 
    wget \ 
    ros-melodic-ackermann-msgs \
    ros-melodic-map-server \ 
    ros-melodic-serial \
    ros-melodic-urg-node \
    ros-melodic-robot-state-publisher \ 
    ros-melodic-xacro \  
    gfortran \
    libopenblas-dev \ 
    liblapack-dev && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/*

RUN conda install -y conda=4.7.12 python=3.7 && conda clean -ay && \
    pip install --no-cache-dir \
    azureml-core==1.35.0 \
    azureml-defaults==1.35.0 \
    azureml-mlflow==1.35.0 \
    azureml-telemetry==1.35.0 \
    rospkg \
    numpy \
    Cython \
    scipy \
    networkx \
    sklearn \
    future==0.17.1 \
    torch==1.4.0 \
    pycryptodome \
    empy \
    vcstool \
    setproctitle && \
    conda install -y -c conda-forge x264='1!152.20180717' ffmpeg=4.0.2 && \
    conda install -c anaconda opencv && \
    conda install tk

CMD ["source /opt/ros/melodic/setup.bash"]
