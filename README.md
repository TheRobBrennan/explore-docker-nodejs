# Welcome

This project was inspired by [Lessons from Building Node Apps in Docker (2019)](https://jdlm.info/articles/2019/09/06/lessons-building-node-app-docker.html).

## Getting started

The easiest way to use this repo is to have [Docker Desktop for Mac/Windows](https://www.docker.com/products/docker-desktop) installed and configured on your development machine.

Once this is complete, you can spin up the project by running:

```sh
# Spin up a local Docker environment
$ npm start
```

Once you have finished with your work - or if you would like to stop the project from running:

```sh
# You can also press CTRL+C to stop the running container
$ npm run docker:down
```

If you would like to build and run the lightweight production image:

```sh
# Notice how much smaller this image is than the development one
$ npm run docker:up:prod
```
