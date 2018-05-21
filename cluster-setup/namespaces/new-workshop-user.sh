#!/bin/bash

function create_workshop_user {
    if [[ -z "$1" ]]; then exit; fi;
    WORKSHOP_USER_NAME=$1

    template=`cat "user-template.yml" | sed "s/{{WORKSHOP_USER_NAME}}/$WORKSHOP_USER_NAME/g"`

    echo "$template" | kubectl apply -f -

    secret_name=`kubectl get secrets -n $WORKSHOP_USER_NAME | awk '$1 ~ /workshop-user-/' | awk {'print $1'}`
    token=`kubectl get secret $secret_name -o jsonpath='{.data.token}' -n $WORKSHOP_USER_NAME | base64 --decode`

    printf '%s\n' "$WORKSHOP_USER_NAME" "$token" | paste -sd ',' - >> tokens.csv

    echo "$token"
}

if [[ -z "$1" ]]; then exit; fi;

create_workshop_user $1