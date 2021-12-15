FROM nvidia/cuda:11.1-cudnn8-devel-ubuntu20.04
SHELL ["/bin/bash", "-c"]

ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /workspace

# Instal basic utilities
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip python3-dev git wget unzip bzip2 build-essential \
        ca-certificates ffmpeg libsm6 libxext6 && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install pytorch
RUN pip3 install torch==1.10.0+cu111 -f https://download.pytorch.org/whl/cu111/torch/ && \
    pip3 install torchvision==0.11.1+cu111 -f https://download.pytorch.org/whl/cu111/torchvision

# # Install mmocr
COPY mmocr/ /workspace/mmocr/
RUN pip3 install mmcv-full==1.3.17 -f https://download.openmmlab.com/mmcv/dist/cu111/torch1.10.0/index.html && \
    pip3 install imgaug==0.4.0 mmdet==2.18.1 && \
    cd mmocr && \
    pip3 install -e .

# # Install paddle
COPY paddleocr/ /workspace/paddleocr/
COPY paddlepaddle_gpu-2.2.1.post112-cp38-cp38-linux_x86_64.whl /workspace/
RUN pip3 install paddlepaddle_gpu-2.2.1.post112-cp38-cp38-linux_x86_64.whl && \
    rm paddlepaddle_gpu-2.2.1.post112-cp38-cp38-linux_x86_64.whl && \
    cd paddleocr && \
    pip3 install scikit-learn editdistance && \
    pip3 install -r requirements.txt

COPY weights/ /workspace/weights
COPY ./mmocr_infer.py ./run.sh ./run_paddle.sh /workspace/

# # ENTRYPOINT ["/bin/bash", "run.sh"]
