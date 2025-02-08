# Use the specific version of Node expected by your Meteor release, per https://docs.meteor.com/changelog.html; this is expected for Meteor 3.0.4
ARG NODE_VERSION=20.18.0
# The tag here should match the Meteor version of your app, per .meteor/release
ARG METEOR_VERSION=3.0.4

FROM jorgenvatle/meteor-base:$METEOR_VERSION AS meteor-base

# Copy app package.json and package-lock.json into container
COPY ./app/package*.json $APP_SOURCE_FOLDER/

RUN bash $SCRIPTS_FOLDER/meteor/npm-install.sh

# Copy app source into container
COPY ./app $APP_SOURCE_FOLDER/

RUN bash $SCRIPTS_FOLDER/meteor/build.sh


FROM node:${NODE_VERSION}-alpine

ENV APP_BUNDLE_FOLDER=/opt/bundle
ENV SCRIPTS_FOLDER=/docker

# Runtime dependencies; if your dependencies need compilation (native modules such as bcrypt) or you are using Meteor <1.8.1, use app-with-native-dependencies.dockerfile instead
RUN apk --no-cache add \
		bash \
		ca-certificates

# Copy in entrypoint
COPY --from=meteor-base $SCRIPTS_FOLDER $SCRIPTS_FOLDER/

# Copy in app bundle
COPY --from=meteor-base $APP_BUNDLE_FOLDER/bundle $APP_BUNDLE_FOLDER/bundle/

RUN bash $SCRIPTS_FOLDER/app/npm-install.sh

# Start app
ENTRYPOINT ["/docker/app/entrypoint.sh"]

CMD ["node", "main.js"]
