#!/usr/bin/env bash

# Script to build a Docker image

if [ "$#" -ne 3 ]; then
    echo "\$1 env file, \$2 image tag, \$3 Dockerfile"
    exit 1
fi

ENV=$1
TAG=$2
DOCKERFILE=$3

if [ -f $ENV ]; then
    source $ENV
    docker build --rm \
        --build-arg KATELLO_ORG=$KATELLO_ORG \
        --build-arg KATELLO_RPM=$KATELLO_RPM \
        --build-arg KATELLO_HOST=$KATELLO_HOST \
        --build-arg KATELLO_USER=$KATELLO_USER \
        --build-arg KATELLO_PASS=$KATELLO_PASS \
        --build-arg BITBUCKET=$BITBUCKET \
        --build-arg REPO=$REPO \
        --no-cache -t $TAG -f $DOCKERFILE .
else
    echo "File $ENV not found"
    exit 1
fi
