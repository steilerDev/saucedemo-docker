#!/bin/bash

handle-stop () {
    echo "Received stop signal..."
    kill -9 $$
}

echo "Starting Sauce Demo!"

DEFAULT_DIR="/opt/orig"
DIFF_DIR="/opt/diff"

if [ "$BRANCH" = "default" ]; then
    echo "Starting Sauce Demo in Default Mode!"
    cd $DEFAULT_DIR
elif [ "$BRANCH" = "diff" ]; then
    echo "Starting Sauce Demo in Diff Mode!"
    cd $DIFF_DIR
else
    echo "No branch specified, aborting..."
    exit
fi
    
npm run start
