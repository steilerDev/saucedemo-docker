#!/bin/bash

DEFAULT_YML="./default.yml"
DEFAULT_CMD="default"
DIFF_YML="./diff.yml"
DIFF_CMD="diff"

ENV_CONFIG_FILE="config.env"
if [ -f $ENV_CONFIG_FILE ]; then
    echo "Loading configuration..."
    export $(cat $ENV_CONFIG_FILE | xargs)
else
    echo "$ENV_CONFIG_FILE not found!"
    exit 1
fi

HOST="https://${LETSENCRYPT_HOST}"

echo -n "Stopping current deployment ..."
docker-compose -f $DEFAULT_YML down -t 0 > /dev/null 2>&1
echo " done"

if [ "$1" = "pull" ]; then
    echo "Updating container image..."
    docker-compose -f $DEFAULT_YML pull
else
    if [ "$1" = "$DEFAULT_CMD" ] || [ -z $1 ]; then
        echo "Bringing default site up ..."
        docker-compose -f $DEFAULT_YML up -d > /dev/null
    elif [ "$1" = "$DIFF_CMD" ]; then
        echo "Bringing diff site up ..."
        docker-compose -f $DIFF_YML up -d > /dev/null
    else
        echo "Unknown argument specified ($1), either '$DEFAULT_CMD' or '$DIFF_CMD'"
        exit 1
    fi

    echo -n "Waiting for site ($HOST) to deploy ..."
    while ! curl -s --head  --request GET $HOST | grep "HTTP/2 200" > /dev/null; do
        echo -n "."
        sleep 1
    done
    echo " done"
    echo "Site up & running @ $HOST"
fi