# Base Docker Image for Meteor Apps
> A rewrite of [geoffreybooth's meteor-base](https://github.com/disney/meteor-base) Docker image.
> Aimed at simplifying the internal process of building and releasing the base Docker images.
>
> ## Notable changes
> - Image builds are automated to address frustrations when new Meteor releases are
> available but the image author hasn't created a new Docker image to match.
> 
> - The default `entrypoint.sh` shipped with the final bundle no longer indefinitely polls for a MongoDB valid connection -
> instead it will exit with an error code. This addresses issues when running images in container orchestration software
> like Kubernetes where containers can invalidly be reported as healthy when in reality it cannot connect to Mongo.
> 
> - Scripts have been refactored to better indicate their expected usage context.
> - Example usage has been refactored to better take advantage for Docker layer caching - significantly speeding up 
> repeated builds when Meteor's dependencies haven't changed.
>
> ### Links
> - **Docker Hub** - https://hub.docker.com/r/jorgenvatle/meteor-base
> - **GitHub repository** - https://github.com/JorgenVatle/meteor-base-revised

This repo contains a base Docker image for use by [Meteor](https://www.meteor.com/) apps built using a [multistage Dockerfile](https://docs.docker.com/develop/develop-images/multistage-build/). You might want to use this base because:

- You can build/bundle your Meteor app as part of building your Docker image, rather than outside of Docker before the Docker build. This means the machine doing the building need not have Node or Meteor installed, which is important for continuous integration setups; and ensures repeatable builds, since the build environment is isolated and controlled.

- Using a multistage `Dockerfile` on your app’s side means that you can publish a much smaller final Docker image that doesn’t have Meteor included, and you can also use an Alpine Linux base which is good for passing security scans (as it presents much less surface area in which scanners might find vulnerabilities).

## Quickstart

### Step 1: Bootstrap `Dockerfile` from template

Copy [`example/Dockerfile`](/example/Dockerfile) into the root of your project. 

### Step 2: Set the correct Meteor version in the `Dockerfile`

Edit the `Dockerfile` you copied into your project, changing the first line so that the numbers at the end match the version of Meteor of your project. You can find your project’s Meteor version in your app’s `.meteor/release` file.

For example, if your project is running under Meteor 3.0.4:

```Dockerfile
FROM jorgenvatle/meteor-base:3.0.4
```

This version must match an available tag from [jorgenvatle/meteor-base](https://hub.docker.com/r/jorgenvatle/meteor-base/tags).

If necessary, update version in the `FROM node` line to use the Node version appropriate for your release of Meteor. From your application folder, you can get this version via the following command:

```bash
docker run --rm jorgenvatle/meteor-base:$(cat ./.meteor/release | cut -c8-99) meteor node --version | cut -c2-99 | grep -o "[0-9\.]*"
```

### Step 3: Configure `.dockerignore` to speed up builds

Copy `example/.dockerignore` to your project’s root and edit it appropriately to avoid copying unnecessary files into the Docker context.

### Step 4: Build and run

Copy `example/docker-compose.yml` to your project’s root. Then, from the root of your project, run:

```bash
docker-compose up
```

This builds an image for your app and starts it, along with a linked container for MongoDB. Go to [http://localhost/](http://localhost/) to see your app running.

### Going further

Feel free to edit the `Dockerfile` you copied into your project, for example to add Linux dependencies. The beauty of the multistage build pattern is that this base image can stay lean, without needing `ONBUILD` triggers or configuration files for you to influence the image that gets built. You control the final image via your own `Dockerfile`, so you can do whatever you want.

If you want any command run on startup before the Meteor app itself is run, have your Dockerfile save a file `startup.sh` into `$SCRIPTS_FOLDER`. It will be executed automatically by `entrypoint.sh`.

## Why this image, instead of some others?

There are several great Meteor Docker images out there. We built this one because none of the existing open source ones met our needs:

- [jshimko/meteor-launchpad](https://github.com/jshimko/meteor-launchpad) is great, but it’s based on `debian:jessie`, which fails the security scan we run on all of our Docker images. Debian is also larger than Alpine. This project also always downloads and installs Meteor on every production build, rather than caching it as this base image does.

- [meteor/galaxy-images](https://github.com/meteor/galaxy-images) and [Treecom/meteor-alpine](https://github.com/Treecom/alpine-meteor) both require building the Meteor app in the host machine, before copying the built app into the Docker container. We wanted to avoid needing Node and Meteor installed on our CI servers, and we want the predictability of building within the Docker environment.

Other projects I looked at generally had one or more of the disadvantages cited above. Multistage Docker builds have only been possible since Docker 17.05, which came out in May 2017, and most projects on the Web were designed before then and therefore don’t take advantage of the possibilities offered by a multistage architecture.

## Contributing

### Adding a new Meteor version

This repository is managed through an action that actively watches Meteor's installer script and creates new images when
there is a new Meteor version available.

For older versions, see `.github/workflows/build-legacy.yml`.