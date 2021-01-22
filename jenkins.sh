#!/bin/bash

set -x
set -e


build_debian() {
    cp emacs-${VERSION}.tar.xz debian/
    PREFIX=/emacs/target

    docker build --build-arg PREFIX=$PREFIX --build-arg VERSION=$VERSION -t emacs-debian debian/

    # debian tags:
    #  * :debian
    #  * :27.1
    #  * :27.1-debian

    docker tag emacs-debian benediktkr/emacs:debian
    docker tag emacs-debian benediktkr/emacs:${VERSION}
    docker tag emacs-debian benediktkr/emacs:${VERSION}-debian

    docker rm emacs-debian-package || true
    docker run --name emacs-debian-package emacs-debian
    docker cp emacs-debian-package:/emacs/debian dist/
    docker rm emacs-debian-package


}

build_amzn () {

    cp emacs-${VERSION}.tar.xz amzn/

    PREFIX=/home/bkristinsson/.local

    docker build --build-arg PREFIX=$PREFIX --build-arg VERSION=$VERSION -t emacs-amzn amzn/

    # amzn tags:
    #  * :amzn
    #  * :27.1-amzn

    docker tag emacs-amzn benediktkr/emacs:amzn
    docker tag emacs-amzn benediktkr/emacs:${VERSION}-amzn

    docker rm emacs-amzn-package || true
    docker run --name emacs-amzn-package emacs-amzn
    docker cp emacs-amzn-package:/emacs/amzn dist/
    docker rm emacs-amzn-package

}

VERSION="27.1"

COPYTO="$(pwd)/dist"
mkdir -p $COPYTO

env

if [ ! -f emacs-${VERSION}.tar.xz ]; then
    wget -q  https://ftp.gnu.org/pub/gnu/emacs/emacs-${VERSION}.tar.xz
fi

if [ "$1" = "debian" ]; then
    build_debian
fi
if [ "$1" = "amzn" ]; then
    build_amzn
fi
