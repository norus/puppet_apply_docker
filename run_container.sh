#!/usr/bin/env bash

if [ "$#" -ne 3 ]; then
    echo "\$1 should be branch, \$2 should be module, \$3 should be container tag"
    exit 1
fi

BRANCH=$1
MODULE=$2
TAG=$3

docker run --rm -e BRANCH=$BRANCH -e MODULE=$MODULE --env-file=etc/env.vars $TAG
