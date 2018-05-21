#!/bin/bash

function delete_workshop_user {
    if [[ -z "$1" ]]; then exit; fi;

    WORKSHOP_USER_NAME=$1

    template=`cat "user-template.yml" | sed "s/{{WORKSHOP_USER_NAME}}/$WORKSHOP_USER_NAME/g"`

    echo "$template" | kubectl delete -f -
}

if [[ -z "$1" ]]; then exit; fi;

delete_workshop_user $1