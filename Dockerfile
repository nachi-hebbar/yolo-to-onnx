FROM  python:3.8.16-slim-bullseye
WORKDIR /home/awiros-docker
RUN apt update -y && apt install vim -y
RUN apt install  build-essential gfortran libatlas-base-dev python3-pip python-dev protobuf-compiler -y
RUN pip install onnx==1.8.1 torch==1.9.1 setuptools scikit-build pandas seaborn cmake protobuf==3.6.1
RUN pip install numpy==1.23.4 requests PyYaml opencv-python IPython psutil torchvision tqdm scipy
RUN apt-get install ffmpeg libsm6 libxext6  -y
CMD ["/bin/bash"]
