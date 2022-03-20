#!/bin/bash

handle-stop () {
    echo "Received stop signal..."
    kill -9 $$
}

echo "Starting Sauce Demo!"

DEFAULT_DIR="/opt/orig"
DIFF_DIR="/opt/diff"


if [ "$BRANCH" = "default" ] || [ -z $BRANCH ]; then
    echo "Starting Sauce Demo in Default Mode!"
    npm run start --prefix $DEFAULT_DIR
elif [ "$BRANCH" = "diff" ]; then
    echo "Starting Sauce Demo in Diff Mode!"
    npm run start --prefix $DIFF_DIR
else
    echo "Unknown branch ($BRANCH) specified, aborting..."
    exit
fi
    
