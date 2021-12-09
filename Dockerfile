FROM nvidia/cuda:11.3.0-base-ubuntu18.04

ARG PYTHON_VERSION=3.8
ARG CONDA_DIR=/opt/conda
ARG PYTORCH_VERSION=1.10.0

WORKDIR /workspace

# Instal basic utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends git wget unzip bzip2 build-essential ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3.sh \
    && bash miniconda3.sh -fbp ${CONDA_DIR} \
    && rm -f miniconda3.sh

ENV PATH ${CONDA_DIR}/bin:${PATH}

# Setup environment for mmocr
RUN conda create -n mmocr python=3.8 && \
    . ${CONDA_DIR}/etc/profile.d/conda.sh && \
    conda activate mmocr && \
    conda install pytorch=${PYTORCH_VERSION} torchvision cudatoolkit=11.3 -c pytorch && \
    pip install mmcv-full==1.3.17 -f https://download.openmmlab.com/mmcv/dist/cu111/torch1.10.0/index.html && \
    pip install imgaug==0.4.0 mmdet==2.18.1 mmocr==0.3.0 && \
    conda clean -ya && \
    pip cache purge
    # git clone https://github.com/open-mmlab/mmocr.git && \
    # cd mmocr && \
    # git checkout 5fb1268a06cd12a3c539a29612be61aabecfd3f8 && \
    # pip install -e .

COPY ./mmocr_infer.py ./run.sh ./weights /workspace/

# ENTRYPOINT ["/bin/bash", "run.sh"]
