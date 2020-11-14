#!/bin/bash

set -e
set -x

if [ "$1" = "shell" ]; then
    exec -l /bin/bash
elif [ "$1" = "emacs" ]; then
    exec $EMACSROOT/bin/emacs
elif [ ! "$1" = "package" ]; then
    echo "invalid args: '$1'"
    exit 1
fi

if [ -z "$VERSION" ]; then
    echo "varible VERSION must be set!"
    exit 1
fi
if [ -z "$PREFIX" ]; then
    PREFIX=/emacs/target
fi

CPU_COUNT=$(grep "processor" -c /proc/cpuinfo)
DIST=/emacs/dist
TARGET=$PREFIX
mkdir -p $TARGET

# we compiled emacs with runpath set to '$ORIGIN/../lib' ($ORIGIN is a
# special token so we can specify a location relative to the
# executable
#
# Same as running
# $ patchelf --set-rpath '$ORIGIN/../lib' $TARGET/bin/emacs
#
# https://www.reddit.com/r/emacs/comments/6nnd6x/selfcontainedrelocatableportable_emacs24_for_linux/dkbbs6h/
#
# copying some lib files
cp /lib64/librt.so.1 $TARGET/lib/
cp /usr/lib64/libgnutls.so.26 $TARGET/lib/

# in the output we see that the binary is dynamically linking the
# files we copied
ldd $TARGET/bin/emacs

mkdir -p $DIST/amzn
# make a tarball
(
    rm $DIST/amzn/czemacs-${VERSION}.tar.gz || true
    cd $TARGET

    tar -cf $DIST/amzn/czemacs-${VERSION}.tar.gz .
)

# copy the compiled $TARGET
(
    rm -rf $DIST/amzn/czemacs-${VERSION} || true
    mkdir -p $DIST/amzn/czemacs-${VERSION}
    cp -r $TARGET/* $DIST/amzn/czemacs-${VERSION}/
)
