ARG tag
FROM node:${tag}

ARG version
LABEL com.plasmops.vendor=PlasmOps \
      com.plasmops.version=$version

ARG TINI_VERSION=v0.18.0
ENV TINI_ENTRYPOINT yes

## Install additional software
#
RUN apt install gnupg

## Tini init installation
RUN \
    cd /tmp && \
    curl --remote-name-all -sSLO https://github.com/krallin/tini/releases/download/${TINI_VERSION}/{tini-amd64,tini-amd64.asc} && \
    export GNUPGHOME=/tmp && \
    for server in ha.pool.sks-keyservers.net \
              hkp://p80.pool.sks-keyservers.net:80 \
              keyserver.ubuntu.com \
              hkp://keyserver.ubuntu.com:80 \
              pgp.mit.edu; do \
        gpg --keyserver "$server" --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && break || echo "Trying new server..."; \
    done && \
    gpg --batch --verify tini-amd64.asc tini-amd64 && mv tini-amd64 /sbin/tini && chmod 755 /sbin/tini && \
    rm -rf /tmp/*

## Install latest Chrome package
#
RUN curl -sSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get install -y google-chrome-stable

COPY /entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

WORKDIR /code
