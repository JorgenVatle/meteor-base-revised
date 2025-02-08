# Based on:
# - https://github.com/jshimko/meteor-launchpad/blob/master/Dockerfile
# - https://github.com/meteor/galaxy-images/blob/master/ubuntu/Dockerfile
# - https://github.com/disney/meteor-base
FROM ubuntu

ENV SCRIPTS_FOLDER=/docker
ENV APP_SOURCE_FOLDER=/opt/src
ENV APP_BUNDLE_FOLDER=/opt/bundle

# Install dependencies, based on https://github.com/jshimko/meteor-launchpad/blob/master/scripts/install-deps.sh (only the parts we plan to use)
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
	apt-get install --assume-yes apt-transport-https ca-certificates && \
	apt-get install --assume-yes --no-install-recommends build-essential bzip2 curl git libarchive-tools python3 nodejs

# Meteor version to build for; see ../build.sh
ARG METEOR_VERSION

# Install Meteor
RUN npx "meteor@$METEOR_VERSION"

# Fix permissions warning; https://github.com/meteor/meteor/issues/7959
ENV METEOR_ALLOW_SUPERUSER=true

# Copy entrypoint and dependencies
COPY ./scripts $SCRIPTS_FOLDER/

# No ONBUILD lines, because this is intended to be used by your app’s multistage Dockerfile and you might need control of the sequence of steps using files from this image
