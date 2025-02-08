#!/bin/bash

set -o errexit

printf "\n[-] Installing Meteor packages...\n\n"

cd $APP_SOURCE_FOLDER

# Remove package.json files to prevent Meteor from trying to access mainModule files that might not exist yet.
rm package*.json

# Running the Meteor lint command seems to be the most reliable way to force Meteor to install local dependencies.
meteor lint || echo "WARN: Failed to run Meteor linter - this only impacts caching for the next build step, so not a huge concern" && exit 0
