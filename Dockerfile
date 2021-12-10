FROM ubuntu:20.04
ARG CONDA_DIR=/opt/conda
SHELL ["/bin/bash", "-c"]

ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /workspace

# Instal basic utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends git wget unzip bzip2 build-essential \
        ca-certificates ffmpeg libsm6 libxext6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3.sh \
    && bash miniconda3.sh -fbp ${CONDA_DIR} \
    && rm -f miniconda3.sh
ENV PATH ${CONDA_DIR}/bin:${PATH}
RUN conda init bash

# Install pytorch first because it is time-consuming
RUN conda create -n mmocr python=3.8 pytorch=1.10.0 torchvision cudatoolkit=11.3 -c pytorch

# Install mmocr
RUN . ${CONDA_DIR}/etc/profile.d/conda.sh && \
    conda activate mmocr && \
    pip install mmcv-full==1.3.17 -f https://download.openmmlab.com/mmcv/dist/cu111/torch1.10.0/index.html && \
    pip install imgaug==0.4.0 mmdet==2.18.1 && \
    git clone https://github.com/open-mmlab/mmocr.git && \
    cd mmocr && \
    git checkout 5fb1268a06cd12a3c539a29612be61aabecfd3f8 && \
    pip install -e .


SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

COPY weights/ /workspace/weights
COPY ./mmocr_infer.py ./run.sh /workspace/
# ENTRYPOINT ["/bin/bash", "run.sh"]
