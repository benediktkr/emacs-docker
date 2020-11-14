#!/bin/bash

set -x
set -e

VERSION="27.1"
PREFIX=/emacs/target

DIST="$(pwd)/dist"

(
    cd debian/
    docker build --build-arg VERSION=$VERSION -t build-emacs-debian .

    docker run -v $DIST/:/emacs/dist --rm -it build-emacs-debian $1
)

# docker image rmi build-emacs-debian