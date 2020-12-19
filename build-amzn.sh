#!/bin/bash

set -x
set -e

VERSION="27.1"
PREFIX=/home/bkristinsson/.local

DIST="$(pwd)/dist"

(
    cd amzn/
    docker build --build-arg PREFIX=$PREFIX --build-arg VERSION=$VERSION build-emacs-amzn .

    docker run --rm -v $DIST:/emacs/dist -t build-emacs-amzn $1
)

# docker rmi build-emacs-amzn
