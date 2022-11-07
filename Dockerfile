# Base image of ubuntu
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive

# Installing build dependecies
RUN apt-get update && \
    apt-get install -y \ 
    apt-utils \
    git \
    tree \
    sudo \
    dpkg-dev \
    autoconf \
    autotools-dev \
    automake \
    pkg-config \
    autoconf-archive \
    build-essential \
    libtool \
    bison \
    liblzma5 \
    liblzma-dev \
    e2fsprogs \
    e2fslibs \
    e2fslibs-dev \
    libgpgme-dev \
    libfuse-dev \
    gtk+-3.0 \
    qemu-utils \
    python3-glanceclient \
    alien \
    unzip \
    golang \
    python3-swiftclient \
    buildah \
    uuid \
    schroot \
    debootstrap \
    && \
    apt-get clean
RUN apt-get upgrade

# Setting up ubuntu user
RUN useradd -m -s /bin/bash ubuntu
RUN echo "ubuntu:test" | chpasswd
RUN adduser ubuntu ubuntu
RUN adduser ubuntu sudo
RUN adduser root ubuntu

# Clone deb-ostree-builder git repository
USER ubuntu
WORKDIR /home/ubuntu
RUN git clone https://github.com/Jianlin-lv/deb-ostree-builder.git

# Preparing script environemnt
USER root
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN mkdir -p /etc/deb-ostree-builder 
#RUN chown root: /var/lock/deb-ostree-builder.lock 

# Running script
WORKDIR /home/ubuntu/deb-ostree-builder
RUN ./deb-ostree-builder -a amd64 -p ubuntu focal --no-checkout -f

# LOGIN AS ROOT

