#!/bin/bash

set -x
set -e


build_debian() {
    cp emacs-${VERSION}.tar.xz debian/
    PREFIX=/emacs/target

    sudo docker build --build-arg PREFIX=$PREFIX --build-arg VERSION=$VERSION -t emacs-debian debian/

    # debian tags:
    #  * :debian
    #  * :27.1
    #  * :27.1-debian

    sudo docker tag emacs-debian benediktkr/emacs:debian
    sudo docker tag emacs-debian benediktkr/emacs:${VERSION}
    sudo docker tag emacs-debian benediktkr/emacs:${VERSION}-debian

    sudo docker rm emacs-debian-package || true
    sudo docker run --name emacs-debian-package emacs-debian
    sudo docker cp emacs-debian-package:/emacs/debian dist/
    sudo docker rm emacs-debian-package


}

build_amzn () {

    cp emacs-${VERSION}.tar.xz amzn/

    PREFIX=/home/bkristinsson/.local

    sudo docker build --build-arg PREFIX=$PREFIX --build-arg VERSION=$VERSION -t emacs-amzn amzn/

    # amzn tags:
    #  * :amzn
    #  * :27.1-amzn

    sudo docker tag emacs-amzn benediktkr/emacs:amzn
    sudo docker tag emacs-amzn benediktkr/emacs:${VERSION}-amzn

    sudo docker rm emacs-amzn-package || true
    sudo docker run --name emacs-amzn-package emacs-amzn
    sudo docker cp emacs-amzn-package:/emacs/amzn dist/
    sudo docker rm emacs-amzn-package

}

VERSION="27.1"

COPYTO="$(pwd)/dist"
mkdir -p $COPYTO

env

if [ ! -f emacs-${VERSION}.tar.xz ]; then
    wget -q  https://ftp.gnu.org/pub/gnu/emacs/emacs-${VERSION}.tar.xz
fi

build_debian
build_amzn
