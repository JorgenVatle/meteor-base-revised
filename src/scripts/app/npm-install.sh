#!/bin/bash

set -o errexit

printf "\n[-] Installing final application's npm dependencies...\n\n"

cd $APP_BUNDLE_FOLDER/bundle/programs/server/
npm install

if [[ "$1" = '--build-from-source' ]]; then
	npm rebuild --build-from-source
	cd $APP_BUNDLE_FOLDER/bundle/programs/server/npm
	npm rebuild --build-from-source
fi
