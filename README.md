# emacs-docker

[![Build Status](https://jenkins.sudo.is/buildStatus/icon?job=ben%2Femacs-docker%2Fmaster&style=flat-square)](https://jenkins.sudo.is/job/ben/job/emacs-docker/job/master/)
![Docker Image Version (latest by date)](https://img.shields.io/docker/v/benediktkr/emacs?style=flat-square)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/benediktkr/emacs?sort=date&style=flat-square)

Builds the latest stable emacs in a docker image, packages it as `.deb` and `.tar.gz` and then publishe a [docker image to Docker Hub](https://hub.docker.com/r/benediktkr/emacs-docker/) with emacs installed.

Currently the `.deb` package has no dependencies and there isn't an apt archive hosting it either.

Dockerfiles for other docker images:

 * `git/Dockerfile`: clone the emacs repo with git and build emacs.
 * `amzn/Dockerfile`: custom Amazon Linux 1 docker build
 * `alpine/Dockerfile`: alpine has up-to-date emacs versions.
