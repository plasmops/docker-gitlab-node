#!/bin/sh
## gitlab-node docker entrypoint file
#
#
set -e


# output error message
err() {
  (>&2 echo "err> $*")
}


# output error message and return with excode
fail() {
  err "$*"
  return ${excode:-1}
}


## GitLab CI setup
#
gitlab() {

  ## Check project URL (we can't proceed if it's not given)
  #  ex: CI_PROJECT_URL="https://mydomain.com/test.ci/token-test"
  #
  [ -z "$CI_PROJECT_URL" ] && fail "CI_PROJECT_URL is unset, doesn't seem we are running in GitLab!"

  GITLAB_DOMAIN="${CI_PROJECT_URL#*//}"
  GITLAB_DOMAIN="${GITLAB_DOMAIN%%/*}"

  ## Populate ~/.netrc to enable npm/yarn operation with other dependent projects hosted by this GitLab
  #
  if [ -n "$CI_JOB_TOKEN" ]; then
    echo "machine ${GITLAB_DOMAIN} login gitlab-ci-token password ${CI_JOB_TOKEN}" >> ~/.netrc
  fi
}


# if we have "--link some-docker:docker" and not DOCKER_HOST, let's set DOCKER_HOST automatically
if [ -z "$DOCKER_HOST" -a "$DOCKER_PORT_2375_TCP" ]; then
  export DOCKER_HOST='tcp://docker:2375'
fi


## -------------------------------------------------
#  Pick up CI system specific configuration function
#

if [ "$CI_SERVER_NAME" = "GitLab" ]; then
  gitlab
fi


# execute command if given or start bash
[ -n "$*" ] && exec "$@" || exec /bin/bash
