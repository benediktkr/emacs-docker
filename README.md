# emacs-docker

[![Build Status](https://jenkins.sudo.is/buildStatus/icon?job=ben%2Femacs-docker%2Fmaster&style=flat-square)](https://jenkins.sudo.is/job/ben/job/emacs-docker/job/master/)

Currently no build system behind this. Images are manually maintained at [hub.docker.com/r/benediktkr/emacs-docker](https://hub.docker.com/r/benediktkr/emacs-docker/).

The `Dockerfile` in `git/` will use an Ubuntu-based image to build the latest version of Emacs from git.

The `Dockerfile` in `alpine/` uses an alpine-based image to run the latest alpine-provided version of Emacs, since they are up-to-date with stable. The `latest` tag points to this version.
