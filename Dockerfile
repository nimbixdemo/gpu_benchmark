FROM nvidia/cuda:11.6.2-devel-ubuntu20.04 as builder
RUN mkdir /home/cuda
WORKDIR /home/cuda
RUN apt-get update -y && apt-get install git -y
RUN git clone https://github.com/NVIDIA/cuda-samples.git
RUN make -C cuda-samples/Samples/1_Utilities/deviceQuery
RUN make -C cuda-samples/Samples/4_CUDA_Libraries/matrixMulCUBLAS
#RUN mv cuda-samples/Samples/1_Utilities/deviceQuery/deviceQuery /usr/bin/deviceQuery
#RUN mv cuda-samples/Samples/4_CUDA_Libraries/matrixMulCUBLAS/matrixMulCUBLAS /usr/bin/matrixMulCUBLAS

FROM us-docker.pkg.dev/jarvice/images/ubuntu-desktop:bionic
RUN apt-get update -y && apt-get install glmark2 -y
COPY --from=builder /home/cuda/cuda-samples/Samples/1_Utilities/deviceQuery/deviceQuery /usr/bin/deviceQuery
COPY --from=builder /home/cuda/cuda-samples/Samples/4_CUDA_Libraries/matrixMulCUBLAS/matrixMulCUBLAS /usr/bin/matrixMulCUBLAS

ADD ./NAE/help.html /etc/NAE/help.html

