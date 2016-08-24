#!/usr/bin/env bash

# THIS FILE IS FOR SYSTEMS WITH SYSTEMD (RHEL/OEL 7)

if [ "$#" -ne 3 ]; then
    echo "\$1 should be branch, \$2 should be module, \$3 should be container tag"
    exit 1
fi

BRANCH=$1
MODULE=$2
TAG=$3

TYPE=$(echo $TAG | cut -d"/" -f1)
SYSTEMD_CONTAINER_NAME="$TYPE"_puppetsystemd
PUPPETTEST_CONTAINER_NAME=$TYPE/puppettest

CONTAINER_ID=$(docker ps -a | grep $SYSTEMD_CONTAINER_NAME | awk '{print $1}')

start_container() {
    docker run --privileged -d --name $SYSTEMD_CONTAINER_NAME $PUPPETTEST_CONTAINER_NAME /sbin/init
}

stop_container() {
    docker stop $1
}

delete_container() {
    docker rm $1
}

# The test command that is getting executed
puppet_apply() {
    docker exec -i $SYSTEMD_CONTAINER_NAME /bin/bash -c "export BRANCH=$BRANCH ; export MODULE=$MODULE ; set -a ; . /env.vars ; set +a ; /puppet_apply.sh"
}

# Start a new container if CONTAINER_ID is empty
if [ -z $CONTAINER_ID ]; then
    CONTAINER_ID=$(start_container)
    puppet_apply
    stop_container $CONTAINER_ID && delete_container $CONTAINER_ID
else
    stop_container $CONTAINER_ID
    if [ $? -eq 0 ]; then
        delete_container $CONTAINER_ID
    else
        echo "Could not remove $CONTAINER_ID"
        exit 1
    fi
fi
