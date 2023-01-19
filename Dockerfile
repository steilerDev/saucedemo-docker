FROM node:16-bullseye
ENV DEBIAN_FRONTEND noninteractive

# Applying fs patch for assets
ADD rootfs.tar.gz /

# Install stuff and remove caches
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install \
        --no-install-recommends \
        --fix-missing \
        --assume-yes \
            apt-utils vim curl wget && \
    apt-get clean autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Serving the statically generated files
RUN npm install -g serve

EXPOSE 3000/tcp

WORKDIR "/opt/"

RUN chmod +x ./entry.sh

ENTRYPOINT ["./entry.sh"]