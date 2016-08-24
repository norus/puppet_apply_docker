#!/usr/bin/env bash

# THIS FILE IS INTENDED TO BE RUN INSIDE A CONTAINER

source /lib/katello_ops.sh
source /lib/git_ops.sh

case "$(rpm -q --queryformat '%{VERSION}' redhat-release-server)" in
    6*)
            KEY="rhel-6-x86_64";;
    7*)
            KEY="rhel-7-x86_64";;
esac

# Register first in case this is RHEL and the module does package installs
if [ ! -f /etc/oracle-release ]; then
    register $HOSTNAME $KEY >/dev/null
    if [ $? -ne 0 ]; then
        echo "Could not register with Katello. Cancelling further tasks."
        exit 1
    fi
fi

########## YOUR TESTS START HERE ##########
clone $BITBUCKET $REPO
cd $REPO && checkout $BRANCH

LANG=en_US.UTF-8 puppet apply --modulepath=/$REPO -e "class {'$MODULE':}"
########## YOUR TESTS END HERE ##########

# Unscubscribe and remove from Katello when you're done
if [ ! -f /etc/oracle-release ]; then
    unregister $HOSTNAME >/dev/null
fi
