FROM    ubuntu:precise

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y python-software-properties python g++ make curl
RUN curl -sL https://deb.nodesource.com/setup_dev | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y octave
RUN apt-get install -y vim
RUN echo 'deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu precise main' >> /etc/apt/sources.list.d/clang.list
RUN echo 'deb-src http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu precise main' >> /etc/apt/sources.list.d/clang.list
RUN echo 'deb http://llvm.org/apt/precise/ llvm-toolchain-precise main' >> /etc/apt/sources.list.d/clang.list
RUN echo 'deb-src http://llvm.org/apt/precise/ llvm-toolchain-precise main' >> /etc/apt/sources.list.d/clang.list
RUN echo 'deb http://llvm.org/apt/precise/ llvm-toolchain-precise-3.5 main' >> /etc/apt/sources.list.d/clang.list
RUN echo 'deb-src http://llvm.org/apt/precise/ llvm-toolchain-precise-3.5 main' >> /etc/apt/sources.list.d/clang.list
RUN echo 'deb http://llvm.org/apt/precise/ llvm-toolchain-precise-3.6 main' >> /etc/apt/sources.list.d/clang.list
RUN echo 'deb-src http://llvm.org/apt/precise/ llvm-toolchain-precise-3.6 main' >> /etc/apt/sources.list.d/clang.list
RUN echo 'deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu precise main' >> /etc/apt/sources.list.d/clang.list
RUN apt-get update
RUN apt-get install -y --force-yes clang-3.5
RUN apt-get install -y sudo
RUN apt-get install -y apparmor-utils
COPY . /src
RUN cd /src; rm -rf node_modules; npm install; make update
RUN cd /src; npm test;
