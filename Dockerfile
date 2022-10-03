FROM debian:bullseye-slim

RUN apt update && \
    apt install -y build-essential cargo cmake libboost-dev libboost-system-dev   \
    libboost-filesystem-dev libcurl4-gnutls-dev libenet-dev libfmt-dev   \
    libfreetype-dev libfreetype6 libfreetype6-dev \
    libgloox-dev libicu-dev \
    libpng-dev libsdl2-dev libsodium-dev libvorbis-dev \
    libxml2-dev python rustc zlib1g-dev libminiupnpc-dev \
    libopenal-dev libogg-dev && \
    apt install -y wget

ENV SHELL=/bin/bash
ENV VERSION=0ad-0.0.26-alpha
ENV WORKDIR_PATH=/home/user0ad
WORKDIR $WORKDIR_PATH
RUN useradd -M -U -d /home/user0ad user0ad
RUN passwd -d user0ad
RUN chown user0ad:user0ad $WORKDIR_PATH
USER user0ad
RUN 'cp $GITHUB_WORKSPACE/data/mod.zip $WORKDIR_PATH; \
/bin/bash -c 'wget https://releases.wildfiregames.com/$VERSION-unix-build.tar.xz; \
sha1sum -c $VERSION-unix-build.tar.gz.sha1sum; \
tar xvf $VERSION-unix-build.tar.xz; \
cd $VERSION/build/workspaces; \
./update-workspaces.sh -j$(nproc) --disable-atlas --without-pch; \
make config=release -C gcc -j$(nproc); \
cd ../../binaries/system; \
rm *.a; \
strip *; \
cd $WORKDIR_PATH; \
mv $VERSION/binaries .; \
mkdir -p binaries/data/mods/mod; \
mv mod.zip binaries/data/mods/mod; \
cp $VERSION/*.txt .; \
rm -rf ${VERSION}*;'

USER root
RUN apt remove -y build-essential cargo cmake *dev rustc python wget
