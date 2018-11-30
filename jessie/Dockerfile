ARG tag
FROM node:${tag}

ARG version
LABEL com.plasmops.vendor=PlasmOps \
      com.plasmops.version=$version

ENV LANG=C.UTF-8

# Docker env variables
ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 18.09.0
ENV DOCKER_SHASUM 08795696e852328d66753963249f4396af2295a7fe2847b839f7102e25e47cb9

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

## AWS tools
RUN \
    pip install awscli && apk add --no-cache groff less mailcap && \
    ( rm -rf /root/.cache /root/.* 2>/dev/null || /bin/true )

## Install docker-ce
#
RUN \
  if ! curl -#fL -o docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz"; then \
    echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for x86_64"; \
    exit 1; \
  fi; \
  \
  tar -xzf docker.tgz \
    --strip-components 1 \
    -C /usr/local/bin && \
  \
  echo "${DOCKER_SHASUM}  docker.tgz" | sha256sum -c && rm docker.tgz
## We don't install custom modprobe, since haven't run into issues yet (see the link bellow)
#  https://github.com/docker-library/docker/blob/master/18.06/modprobe.sh
#

COPY /entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

WORKDIR /code