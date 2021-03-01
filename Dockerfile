FROM nvcr.io/nvidia/tensorrt:20.09-py3

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
        cat /usr/local/cuda/version.txt &&\
	cat /usr/include/cudnn.h | grep CUDNN_MAJOR -A 2 &&\
	dpkg -l | grep TensorRT &&\
	echo $(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")
  
RUN pip3 install torch torchvision requests
RUN git clone https://github.com/NVIDIA-AI-IOT/torch2trt.git
RUN cd torch2trt && python3 setup.py install
RUN mkdir -p ~/catkin_ws/src
RUN cd ~/catkin_ws/src
RUN git clone https://github.com/ros/catkin.git 
RUN git clone https://github.com/PRBonn/rangenet_lib.git
RUN cd .. && catkin init
RUN catkin build rangenet_lib
