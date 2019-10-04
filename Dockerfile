FROM debian:9.11

MAINTAINER willehkey@mailoo.org

RUN apt-get update \
    && apt-get install -y build-essential pkg-config automake libtool git zlib1g-dev libboost-dev \
    libboost-system-dev libboost-chrono-dev libboost-random-dev libssl-dev libgeoip-dev \
    libtorrent-rasterbar-dev qt5-default qttools5-dev-tools

RUN mkdir /qbittorrent \
    && mkdir /libtorrent

WORKDIR /libtorrent

RUN git clone https://github.com/arvidn/libtorrent.git .
RUN git checkout $(git tag | grep libtorrent_1_1_ | sort -t _ -n -k 4 | tail -n 1)
RUN ./autotool.sh
RUN ./configure --disable-debug --enable-encryption
RUN make clean && make
RUN make install

WORKDIR /qbittorrent

RUN git clone https://github.com/qbittorrent/qBittorrent .
RUN git checkout v4_1_x
RUN dpkg -l | grep -i torrent
RUN ./configure --disable-gui
RUN make
