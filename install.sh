#!/bin/bash

# This is an installer script, that can be pulled from Github, to locally setup the docker-compose files and/or update them.

GH_BASE_URL="https://raw.githubusercontent.com/steilerDev/saucedemo-docker/main/docker-compose.d"

ENV_CONFIG_FILE="config.env"

remote_files=("default.yml" "deploy.sh" "diff.yml")
for file in "${array[@]}"; do
    if [ -f $file ]; then
        echo "$file already exists locally, deleting..."
        rm $file
    fi
    wget -O $file "$GH_BASE_URL/$file"
    if [[ $file == .sh ]]; then
        echo "Making shell script executable..."
        chmod +x $file
    fi
done

if [ -f $ENV_CONFIG_FILE ]; then
    echo "Environment already configured, skipping..."
else
    echo "Environment not congigured, performing now..."
    echo "Enter domain name (VIRTUAL_HOST, LETSENCRYPT_HOST):"
    read DEMO_DOMAIN

    echo "Enter email (LETSENCRYPT_EMAIL)"
    read DEMO_EMAIL

    echo "VIRTUAL_HOST: \"$DEMO_DOMAIN\"" >> $ENV_CONFIG_FILE
    echo "LETSENCRYPT_HOST: \"$DEMO_DOMAIN\"" >> $ENV_CONFIG_FILE
    echo "LETSENCRYPT_EMAIL: \"$DEMO_EMAIL\"" >> $ENV_CONFIG_FILE
fi

echo
echo "You are good to go!"
echo "Run './deploy.sh default' to bring default site up"
echo "Run './deploy.sh diff' to bring modified site up"