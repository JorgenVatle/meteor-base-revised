# Use the specific version of Node expected by your Meteor release, per https://docs.meteor.com/changelog.html; this is expected for Meteor 3.0.4
ARG NODE_VERSION=22.18

# The tag here should match the Meteor version of your app, per .meteor/release
ARG METEOR_VERSION=3.3

FROM jorgenvatle/meteor-base:$METEOR_VERSION AS production-bundle

# Install npm dependencies
COPY --link ./package*.json $APP_SOURCE_FOLDER/
RUN bash $SCRIPTS_FOLDER/meteor/npm-install.sh

# Install Meteor's packages; speeds up the following build step if your Meteor dependencies haven't changed since the last build
COPY --link ./.meteor $APP_SOURCE_FOLDER/.meteor
RUN bash $SCRIPTS_FOLDER/meteor/atmosphere-install.sh

# Bundle app for production
COPY --link . $APP_SOURCE_FOLDER/
RUN bash $SCRIPTS_FOLDER/meteor/build.sh


FROM node:${NODE_VERSION}-alpine
ENV APP_BUNDLE_FOLDER=/opt/bundle
ENV SCRIPTS_FOLDER=/docker

# Install runtime dependencies
RUN apk --no-cache add \
		bash \
		ca-certificates

# Copy in entrypoint and app bundle
COPY --link --from=production-bundle $SCRIPTS_FOLDER $SCRIPTS_FOLDER/
COPY --link --from=production-bundle $APP_BUNDLE_FOLDER/bundle $APP_BUNDLE_FOLDER/bundle/

# Install production bundle's npm dependencies
RUN bash $SCRIPTS_FOLDER/app/npm-install.sh

# Start app
ENTRYPOINT ["sh", "-c", "$SCRIPTS_FOLDER/app/entrypoint.sh"]
CMD ["node", "main.js"]
