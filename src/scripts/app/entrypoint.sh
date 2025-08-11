#!/usr/bin/env sh

set -o errexit

cd "$SCRIPTS_FOLDER"

# Source an init script that a child image may have added
if [ -x ./startup.sh ]; then
	source ./startup.sh
fi

echo 'Starting app...'
cd "$APP_BUNDLE_FOLDER/bundle"

exec "$@"
