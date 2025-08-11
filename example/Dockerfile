# Use the specific version of Node expected by your Meteor release, per https://docs.meteor.com/changelog.html; this is expected for Meteor 3.0.4
ARG NODE_VERSION=22.18

# The tag here should match the Meteor version of your app, per .meteor/release
ARG METEOR_VERSION=3.3

# Path to the root directory of the Meteor app to build.
# Can be left empty unless your app is nested under some other directory
ARG METEOR_APP_ROOT

FROM jorgenvatle/meteor-base:$METEOR_VERSION AS meteor-base
ARG METEOR_APP_ROOT

# Install npm dependencies
COPY --link $METEOR_APP_ROOT/package*.json $APP_SOURCE_FOLDER/
RUN bash $SCRIPTS_FOLDER/meteor/npm-install.sh

# Install Meteor's packages; speeds up the following build step if your Meteor dependencies haven't changed since the last build
COPY --link $METEOR_APP_ROOT/.meteor $APP_SOURCE_FOLDER/.meteor
RUN bash $SCRIPTS_FOLDER/meteor/atmosphere-install.sh

# Bundle app for production
COPY --link $METEOR_APP_ROOT $APP_SOURCE_FOLDER/
RUN bash $SCRIPTS_FOLDER/meteor/build.sh


FROM node:${NODE_VERSION}-alpine
ENV APP_BUNDLE_FOLDER=/opt/bundle
ENV SCRIPTS_FOLDER=/docker

# Runtime dependencies; if your dependencies need compilation (native modules such as bcrypt) or you are using Meteor <1.8.1, use app-with-native-dependencies.dockerfile instead
RUN apk --no-cache add \
		bash \
		ca-certificates

# Copy in entrypoint and app bundle
COPY --link --from=meteor-base $SCRIPTS_FOLDER $SCRIPTS_FOLDER/
COPY --link --from=meteor-base $APP_BUNDLE_FOLDER/bundle $APP_BUNDLE_FOLDER/bundle/

# Install dependencies
RUN bash $SCRIPTS_FOLDER/app/npm-install.sh

# Start app
ENTRYPOINT ["${SCRIPTS_FOLDER}/app/entrypoint.sh"]
CMD ["node", "main.js"]
