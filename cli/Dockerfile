ARG tag
FROM node:${tag}-alpine

ARG version
LABEL com.plasmops.vendor=PlasmOps \
      com.plasmops.version=${version}


ENV LANG=C.UTF-8

# Docker env variables
ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 18.06.1-ce
ENV DOCKER_SHASUM 83be159cf0657df9e1a1a4a127d181725a982714a983b2bdcc0621244df93687

## Install build software
#
RUN apk add --no-cache --update \
        curl bash git tar jq \
        git binutils coreutils findutils file build-base

## Install python 2.7
#
RUN apk add --no-cache --update python python-dev && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip install --upgrade pip setuptools && \
    ( rm -rf /root/.cache /root/.* 2>/dev/null || /bin/true )

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

## Additional softare and modules for devs
#
RUN \
  yarn global add nodemon

COPY /entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
