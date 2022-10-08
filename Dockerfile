FROM andy5995/0ad-bin-nodata:appimage-latest
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y jq
USER user0ad
WORKDIR /home/user0ad
COPY /package_mod usr/data/mods/package_mod
USER root

