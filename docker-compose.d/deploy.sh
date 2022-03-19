#!/bin/bash

HOST="https://saucedemo.steilergroup.net"

echo -n "Stopping current deployment ..."
docker-compose -f ./default.yml down -t 0 > /dev/null 2>&1
echo " done"

if [ "$1" = "default" ]; then
    echo "Bringing default site up ..."
    docker-compose -f ./default.yml up -d > /dev/null
elif [ "$1" = "diff" ]; then
    echo "Bringing diff site up ..."
    docker-compose -f ./diff.yml up -d > /dev/null
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