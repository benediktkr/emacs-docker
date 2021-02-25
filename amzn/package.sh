#!/bin/bash

set -e
set -x


BUILDS=/emacs/amzn

# we compiled emacs with runpath set to '$ORIGIN/../lib' ($ORIGIN is a
# special token so we can specify a location relative to the
# executable
#
# Same as running
# $ patchelf --set-rpath '$ORIGIN/../lib' $PREFIX/bin/emacs
#
# https://www.reddit.com/r/emacs/comments/6nnd6x/selfcontainedrelocatableportable_emacs24_for_linux/dkbbs6h/
#
# copying some lib files
cp /lib64/librt.so.1 $PREFIX/lib/
cp /usr/lib64/libgnutls.so.26 $PREFIX/lib/

# in the output we see that the binary is dynamically linking the
# files we copied
ldd $PREFIX/bin/emacs

mkdir -p $BUILDS

# make a tarball
(
    rm $BUILDS/czemacs-${VERSION}.tar.gz || true

    cd $PREFIX
    tar -czf $BUILDS/czemacs-${VERSION}.tar.gz *
)
