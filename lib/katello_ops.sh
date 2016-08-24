#!/usr/bin/env bash

# THIS FILE IS INTENDED TO BE SOURCED

USER=$(echo -n $KATELLO_USER | base64 -d)
PASS=$(echo -n $KATELLO_PASS | base64 -d)

register() {
    rpm -qa | grep katello-ca-consumer || rpm -ivh http://$KATELLO_HOST/pub/$KATELLO_RPM
    subscription-manager register --name=$1 --org=$KATELLO_ORG --activationkey=$2 --force
    subscription-manager attach --auto
}

unregister() {
    subscription-manager remove --all
    subscription-manager unregister
    subscription-manager clean
    curl -s -k -u $USER:$PASS -X DELETE -H "Content-Type:application/json" -H "Accept:application/json" https://$KATELLO_HOST/api/v2/hosts/$1
}
