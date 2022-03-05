FROM node:12

WORKDIR /usr/app

RUN apt-get clean && apt-get update && \
    apt-get install -y locales make gcc wget g++ python curl wget \
    libxml2-dev sshfs tmux supervisor

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN localedef -f UTF-8 -i en_US en_US.UTF-8

RUN git clone https://github.com/c9/core.git c9sdk
RUN cd c9sdk \
    && ./scripts/install-sdk.sh

# Java Environment
ENV JAVA_VERSION=jdk-17.0.1
RUN mkdir -p /usr/java/openjdk && \
    cd /usr/java/openjdk && \
    wget https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_linux-x64_bin.tar.gz && \
    tar -xzvf openjdk-17.0.1_linux-x64_bin.tar.gz
RUN echo export JAVA_HOME=/usr/java/openjdk/jdk-17.0.1 >> /etc/profile
RUN echo export PATH='/usr/java/openjdk/jdk-17.0.1/bin:$PATH' >> /etc/profile

WORKDIR /usr/app
RUN mkdir workspace
CMD node ./c9sdk/server.js -l 0.0.0.0 -p 8080 -a root:rootpass -w ./workspace/
