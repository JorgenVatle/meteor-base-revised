#!/bin/bash

set -o errexit

printf "\n[-] Installing Meteor's Atmosphere dependencies...\n\n"

cd $APP_SOURCE_FOLDER

# Remove package.json files to prevent Meteor from trying to access mainModule files that might not exist yet.
rm package*.json

meteor lint
