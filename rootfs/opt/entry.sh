#!/bin/bash

handle-stop () {
    echo "Received stop signal..."
    kill -9 $$
}

echo "Starting Sauce Demo!"

BUILD_VANILLA="/opt/vanilla"
BUILD_MOD="/opt/mod"


if [ "$BRANCH" = "default" ] || [ -z $BRANCH ]; then
    echo "Starting Sauce Demo in Default Mode!"
    serve -n -u -d --no-etag $BUILD_VANILLA
elif [ "$BRANCH" = "diff" ]; then
    echo "Starting Sauce Demo in Diff Mode!"
    serve -n -u -d --no-etag $BUILD_MOD
else
    echo "Unknown branch ($BRANCH) specified, aborting..."
    exit
fi
    
