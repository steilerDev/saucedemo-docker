#!/bin/bash

DEFAULT_YML="./default.yml"
DEFAULT_CMD="default"
DIFF_YML="./diff.yml"
DIFF_CMD="diff"
ENV_CONFIG_FILE="config.env"

if [ "$1" = "pull" ]; then
    echo "Updating container image..."
    docker compose -f $DEFAULT_YML pull
    echo " done"
elif [ "$1" = "down" ]; then
    echo -n "Stopping current deployment ..."
    docker compose -f $DEFAULT_YML down -t 0 > /dev/null 2>&1
    echo " done"
elif [ "$1" = "up" ]; then
    if [ -f $ENV_CONFIG_FILE ]; then
        echo "Loading configuration..."
        export $(cat $ENV_CONFIG_FILE | xargs)
    else
        echo "$ENV_CONFIG_FILE not found!"
        exit 1
    fi
    echo " done"

    HOST="https://${LETSENCRYPT_HOST}"

    if [ "$2" = "$DEFAULT_CMD" ] || [ -z $2 ]; then
        echo "Bringing default site up ..."
        docker compose -f $DEFAULT_YML up -d > /dev/null
    elif [ "$2" = "$DIFF_CMD" ]; then
        echo "Bringing diff site up ..."
        docker compose -f $DIFF_YML up -d > /dev/null
    else
        echo "Unknown argument specified ($2), either '$DEFAULT_CMD' or '$DIFF_CMD'"
        exit 1
    fi
    echo " done"


    echo -n "Waiting for site ($HOST) to deploy "
    while ! curl -s --head  --request GET $HOST | grep "HTTP/2 200" > /dev/null; do
        echo -n "."
        sleep 1
    done
    echo " done"

    echo "Site up & running @ $HOST"
    echo 
    echo "On Safari: Use '<cmd> <opt> e' to clear cache"
else
    echo "Sauce Demo helper script."
    echo
    echo "Usage: $0 <command>"
    echo "  Possible commands:"
    echo "   - 'pull': Pulls the latest image from DockerHub"
    echo "   - 'down': Stops the current deployment"
    echo "   - 'up <branch>': Starts the deployment using the specified <branch>. Either 'default' (or empty) for unmodified version, or 'diff' for changed login page."
    echo
    echo "Build by steilerDev - https://github.com/steilerDev/saucedemo-docker"
fi