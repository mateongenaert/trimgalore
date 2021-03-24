FROM ubuntu:20.04
MAINTAINER mongenae@its.jnj.com

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

ENV PACKAGES git gcc make g++ libboost-all-dev liblzma-dev libbz2-dev \
    ca-certificates zlib1g-dev libcurl4-openssl-dev curl unzip autoconf apt-transport-https ca-certificates gnupg software-properties-common wget openjdk-11-jre openjdk-11-jre-headless curl unzip python3-pip pigz

ENV FASTQC_VERSION 0.11.9

WORKDIR /home

RUN apt-get update && \
    apt remove -y libcurl4 && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean

RUN apt-get update

WORKDIR /home

RUN wget --no-check-certificate https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTQC_VERSION}.zip
RUN unzip fastqc_v${FASTQC_VERSION}.zip
WORKDIR /home/FastQC
RUN chmod 755 ./fastqc
RUN ln -s /home/FastQC/fastqc /usr/local/bin/fastqc

ENV PATH /home/FastQC/:${PATH}
ENV LD_LIBRARY_PATH "/usr/local/lib:${LD_LIBRARY_PATH}"

RUN echo "export PATH=$PATH" > /etc/environment
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" > /etc/environment

# Install cutadapt
ENV CUTADAPT_VERSION 3.3
RUN pip3 install cutadapt==${CUTADAPT_VERSION}

# Install trim_galore
WORKDIR /home
ENV TRIM_GALORE_VERSION 0.6.6

RUN curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/${TRIM_GALORE_VERSION}.tar.gz -o trim_galore.tar.gz
RUN tar xvzf trim_galore.tar.gz

ENV PATH /home/TrimGalore-${TRIM_GALORE_VERSION}/:${PATH}
ENV LD_LIBRARY_PATH "/usr/local/lib:${LD_LIBRARY_PATH}"

RUN echo "export PATH=$PATH" > /etc/environment
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" > /etc/environment
