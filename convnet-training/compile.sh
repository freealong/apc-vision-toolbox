#!/bin/bash

export PATH=$PATH:/usr/local/cuda/bin

if uname | grep -q Darwin; then
  CUDA_LIB_DIR=/usr/local/cuda/lib
  CUDNN_LIB_DIR=/usr/local/cudnn/v5/lib
elif uname | grep -q Linux; then
  CUDA_LIB_DIR=/usr/local/cuda/lib64
  CUDNN_LIB_DIR=/home/yongqi/Downloads/cuda/lib64
fi

nvcc -ccbin /usr/bin/g++ -std=c++11 -O3 -o marvin marvin.cu -I./util -I/usr/local/cuda/include -I/home/yongqi/Downloads/cuda/include -L$CUDA_LIB_DIR -L$CUDNN_LIB_DIR -lcudart -lcublas -lcudnn -lcurand -D_MWAITXINTRIN_H_INCLUDED `pkg-config --cflags opencv` `pkg-config --libs opencv`
