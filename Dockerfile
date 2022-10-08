FROM andy5995/0ad-bin-nodata:appimage-latest
USER user0ad
WORKDIR /home/user0ad
COPY /package_mod usr/data/mods/package_mod
USER root

