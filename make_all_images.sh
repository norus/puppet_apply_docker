#!/usr/bin/env bash

# Script to build all our Docker images (see $IMAGES array)

# time ./make_all_images.sh base
# Making base image for rhel6... [DONE]
# Making base image for rhel7... [DONE]
# Making base image for oel5... [DONE]
# Making base image for oel6... [DONE]
# Making base image for oel7... [DONE]

# real    15m18.831s
# user    0m0.133s
# sys     0m0.085s

if [ "$#" -ne 1 ]; then
    echo "\$1 should be 'base|test'"
    exit 1
fi

set -e

IMAGE_TYPE=$1
IMAGES=('rhel6' 'rhel7' 'oel5' 'oel6' 'oel7')

for i in "${IMAGES[@]}"; do
    echo -n "Making base image for $i... "
    ./make_image.sh etc/env.vars $i/puppet$IMAGE_TYPE Dockerfile_$i-puppet$IMAGE_TYPE > /dev/null
    echo "[DONE]"
done
