ARG VERSION=0.27.0
FROM andy5995/0ad-bin-nodata:appimage-$VERSION
USER user0ad
WORKDIR /home/user0ad
COPY /package_mod usr/data/mods/package_mod
USER root

