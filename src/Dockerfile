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
	apt-get install --assume-yes --no-install-recommends build-essential bzip2 curl git libarchive-tools python3

# Meteor version to build for; see ../build.sh
ARG METEOR_VERSION

RUN curl https://install.meteor.com/?release=$METEOR_VERSION --output /tmp/install-meteor.sh && \
	# Replace tar with bsdtar in the install script; https://github.com/jshimko/meteor-launchpad/issues/39 and https://github.com/intel/lkp-tests/pull/51
	sed --in-place "s/tar -xzf.*/bsdtar -xf \"\$TARBALL_FILE\" -C \"\$INSTALL_TMPDIR\"/g" /tmp/install-meteor.sh && \
	# Install Meteor
	printf "\n[-] Installing Meteor $METEOR_VERSION...\n\n" && \
	sh /tmp/install-meteor.sh

# Fix permissions warning; https://github.com/meteor/meteor/issues/7959
ENV METEOR_ALLOW_SUPERUSER=true

# Copy entrypoint and dependencies
COPY ./scripts $SCRIPTS_FOLDER/

# No ONBUILD lines, because this is intended to be used by your app’s multistage Dockerfile and you might need control of the sequence of steps using files from this image
