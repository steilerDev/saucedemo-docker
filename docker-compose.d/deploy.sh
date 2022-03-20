#!/bin/bash

HOST="https://saucedemo.steilergroup.net"
DEFAULT_YML="./default.yml"
DIFF_YML="./diff.yml"

echo -n "Stopping current deployment ..."
docker-compose -f $DEFAULT_YML down -t 0 > /dev/null 2>&1
echo " done"

if [ "$1" = "pull" ]; then
    echo "Updating container image..."
    docker-compose -f $DEFAULT_YML pull
else
    if [ "$1" = "default" ]; then
        echo "Bringing default site up ..."
        docker-compose -f $DEFAULT_YML up -d > /dev/null
    elif [ "$1" = "diff" ]; then
        echo "Bringing diff site up ..."
        docker-compose -f $DIFF_YML up -d > /dev/null
    else
        echo "No argument specified, either 'default' or 'diff'"
    fi

    echo -n "Waiting for site to deploy ..."
    while ! curl -s --head  --request GET $HOST | grep "HTTP/2 200" > /dev/null; do
        echo -n "."
        sleep 1
    done
    echo " done"
    echo "Site up & running @ $HOST"
fi