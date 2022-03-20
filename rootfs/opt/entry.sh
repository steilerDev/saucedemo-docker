#!/bin/bash

handle-stop () {
    echo "Received stop signal..."
    kill -9 $$
}
trap handle-stop SIGTERM

VANILLA_BRANCH_NAME="default"
MOD_BRANCH_NAME="diff"

BUILD_VANILLA="/opt/vanilla"
BUILD_MOD="/opt/mod"

DEFAULT_PORT=3000

echo "Starting Sauce Demo on port ${PORT:=$DEFAULT_PORT}, using branch ${BRANCH:=$VANILLA_BRANCH_NAME}"

if [ "$BRANCH" = "$VANILLA_BRANCH_NAME" ]; then
    echo "Starting Sauce Demo in Default Mode!"
    serve -n -u -d --no-etag -l $PORT $BUILD_VANILLA
elif [ "$BRANCH" = "$MOD_BRANCH_NAME" ]; then
    echo "Starting Sauce Demo in Diff Mode!"
    serve -n -u -d --no-etag -l $PORT $BUILD_MOD
else
    echo "Unknown branch ($BRANCH) specified, aborting..."
    exit
fi
    
