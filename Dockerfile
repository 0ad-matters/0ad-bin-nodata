FROM debian:bullseye-slim

RUN apt-get update -qq && apt-get upgrade -qq -y && \
    apt install -qq -y build-essential cargo cmake libboost-dev libboost-system-dev   \
    libboost-filesystem-dev libcurl4-gnutls-dev libenet-dev libfmt-dev   \
    libfreetype-dev libfreetype6 libfreetype6-dev \
    libgloox-dev libicu-dev \
    libpng-dev libsdl2-dev libsodium-dev libvorbis-dev \
    libxml2-dev python rustc zlib1g-dev libminiupnpc-dev \
    libopenal-dev libogg-dev && \
    apt-get install -qq -y wget git

ENV SHELL=/bin/bash
ENV VERSION=0ad-0.0.26-alpha
ENV WORKDIR_PATH=/home/user0ad
WORKDIR $WORKDIR_PATH
RUN useradd -M -U -d /home/user0ad user0ad
RUN passwd -d user0ad
RUN chown user0ad:user0ad $WORKDIR_PATH
USER user0ad
RUN /bin/bash -c 'wget -nv https://releases.wildfiregames.com/$VERSION-unix-build.tar.xz; \
sha1sum -c $VERSION-unix-build.tar.xz.sha1sum; \
tar xf $VERSION-unix-build.tar.xz; \
cd $VERSION/binaries/data/mods; \
git clone --depth 1 https://github.com/StanleySweet/package_mod; \
cd package_mod; \
git reset --hard 6e520de; \
rm -rf .git; \
cd $WORKDIR_PATH; \
cd $VERSION/build/workspaces; \
./update-workspaces.sh -j$(nproc) --disable-atlas --without-pch > /dev/null; \
make config=release -C gcc -j$(nproc) > /dev/null; \
cd ../../binaries/system; \
rm *.a; \
strip *; \
cd $WORKDIR_PATH; \
mv $VERSION/binaries .; \
rm -rf binaries/data/mods/_test*; \
cp $VERSION/*.txt .; \
rm -rf ${VERSION}*'

USER root
RUN apt purge -qq -y build-essential cargo cmake *dev rustc python wget git
