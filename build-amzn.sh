#!/bin/bash

set -x
set -e

VERSION="27.1"
PREFIX=/home/bkristinsson/.local

DIST="$(pwd)/dist"

(
    cd amzn/
    wget -q  https://ftp.gnu.org/pub/gnu/emacs/emacs-${VERSION}.tar.xz

    docker build --build-arg PREFIX=$PREFIX --build-arg VERSION=$VERSION -t build-emacs-amzn .
    docker run --rm -v $DIST:/emacs/dist build-emacs-amzn $1
)
# docker rmi build-emacs-amzn
