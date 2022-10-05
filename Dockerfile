FROM andy5995/0ad-build-env:bullseye

ENV SHELL=/bin/bash
ENV VERSION=0ad-0.0.26-alpha
ENV HOME_DIR=/home/user0ad
WORKDIR $HOME_DIR
RUN useradd -M -U user0ad
RUN passwd -d user0ad
RUN chown user0ad:user0ad $HOME_DIR
USER user0ad
RUN wget -nv https://releases.wildfiregames.com/$VERSION-unix-build.tar.xz
RUN wget -nv https://releases.wildfiregames.com/$VERSION-unix-build.tar.xz.sha1sum
RUN sha1sum -c $VERSION-unix-build.tar.xz.sha1sum
RUN tar xf $VERSION-unix-build.tar.xz
RUN git clone --depth 1 https://github.com/StanleySweet/package_mod $VERSION/binaries/data/mods/package_mod

RUN cd $VERSION/binaries/data/mods/package_mod \
    && git reset --hard 6e520de \
    && rm -rf .git

WORKDIR $HOME_DIR/$VERSION/build/workspaces/
RUN ./update-workspaces.sh -j$(nproc) --disable-atlas --without-pch > /dev/null
RUN make config=release -C gcc -j$(nproc) > /dev/null

WORKDIR  $HOME_DIR/$VERSION/binaries/system
RUN rm *.a
RUN strip *
WORKDIR $HOME_DIR
RUN mv $VERSION/binaries .
RUN rm -rf binaries/data/mods/_test*
COPY $VERSION/*.txt binaries

FROM debian:bullseye-slim
RUN apt-get update -y -qq && apt-get upgrade -qq -y && apt-get install -y -qq \
  libboost-system1.74.0   \
  libboost-filesystem1.74.0 \
  libcurl4-gnutls-dev \
  libenet7 \
  libfmt7 \
  libfreetype6 \
  libgloox18 \
  libicu67 \
  libpng16-16 \
  libsdl2-2.0-0 \
  libsodium23 \
  libvorbis0a \
  libxml2 \
  zlib1g \
  libminiupnpc17 \
  libopenal1 \
  libogg0

RUN useradd -M -U user0ad
RUN passwd -d user0ad
WORKDIR /home/user0ad
RUN mkdir binaries
COPY --from=0 /home/user0ad/binaries binaries
RUN chown -R user0ad:user0ad /home/user0ad
