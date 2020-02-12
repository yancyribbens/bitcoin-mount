FROM ubuntu:18.04
maintainer yancy ribbens "email@yancy.lol"

RUN apt-get update -qq && apt-get install -y \
    git \
    wget \
    build-essential \
    libtool \
    autotools-dev \
    automake \
    pkg-config \
    libssl-dev \
    libevent-dev \
    bsdmainutils \
    python3 \
    libboost-all-dev

# Install Berkley Database
RUN wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
RUN tar -xvf db-4.8.30.NC.tar.gz
RUN cd ./db-4.8.30.NC/build_unix && \
    mkdir -p build && BDB_PREFIX=$(pwd)/build && \
    ../dist/configure --disable-shared --enable-cxx --with-pic --prefix=$BDB_PREFIX && \
    make install
RUN echo "BDB_PREFIX=\"/db-4.8.30.NC/build_unix/build\"; export BDB_PREFIX" >> ~/.bashrc

RUN mkdir /usr/local/bitcoin
WORKDIR /usr/local/bitcoin

ENTRYPOINT ["/bin/sh", "-c", "./run_bitcoin.sh"] 