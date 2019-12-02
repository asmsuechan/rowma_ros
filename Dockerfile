FROM ros:kinetic-robot

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 && \
    apt-get update && \
    apt-get install python2.7 python-pip python3-pip ros-kinetic-base-local-planner ros-kinetic-camera-calibration ros-kinetic-camera-calibration-parsers ros-kinetic-desktop-full -y && \
    pip install --upgrade pip
RUN apt-get install -y python-rospy
RUN apt-get install -y ros-kinetic-rosbridge-server

COPY . /root/my_workspace/src/rowma_ros

SHELL ["/bin/bash", "-c"]
RUN source /opt/ros/kinetic/setup.bash && \
    catkin_init_workspace && \
    git clone https://github.com/leggedrobotics/ros_best_practices /tmp/ros_best_practices && \
    mv -f /tmp/ros_best_practices/ros_package_template /root/my_workspace/src/ && \
    cd /root/my_workspace/src/rowma_ros && \
    pip2 install -r requirements.txt && \
    pip2 install path.py pytest && \
    cd /root/my_workspace && \
    catkin_make && \
    echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc && \
    echo "source /root/my_workspace/devel/setup.bash" >> ~/.bashrc

CMD ["python", "/root/my_workspace/src/rowma_ros/test/test_utils.py"]
