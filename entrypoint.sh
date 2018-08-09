#!/bin/sh

# if we have "--link some-docker:docker" and not DOCKER_HOST, let's set DOCKER_HOST automatically
if [ -z "$DOCKER_HOST" -a "$DOCKER_PORT_2375_TCP" ]; then
  export DOCKER_HOST='tcp://docker:2375'
fi

# execute command if given or start bash
[ -n "$*" ] && exec $@ || exec /bin/bash
