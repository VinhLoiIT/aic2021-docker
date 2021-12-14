FROM pytorch/pytorch:1.10.0-cuda11.3-cudnn8-runtime
SHELL ["/bin/bash", "-c"]

ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /workspace

# Instal basic utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends git wget unzip bzip2 build-essential \
        ca-certificates ffmpeg libsm6 libxext6 python3.8-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install mmocr
RUN pip install mmcv-full==1.3.17 -f https://download.openmmlab.com/mmcv/dist/cu111/torch1.10.0/index.html && \
    pip install imgaug==0.4.0 mmdet==2.18.1 && \
    git clone https://github.com/open-mmlab/mmocr.git && \
    cd mmocr && \
    git checkout 5fb1268a06cd12a3c539a29612be61aabecfd3f8 && \
    pip install -e .

# Install paddle
COPY paddleocr/ /workspace/paddleocr/
RUN cd paddleocr && \
    pip install -q -r requirements.txt && \
    pip install -q paddlepaddle-gpu==2.0.0 -i https://mirror.baidu.com/pypi/simple

COPY weights/ /workspace/weights
COPY ./mmocr_infer.py ./run.sh /workspace/

# ENTRYPOINT ["/bin/bash", "run.sh"]
