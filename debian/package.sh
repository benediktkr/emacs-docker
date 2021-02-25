#!/bin/bash

set -e
set -x

if [ -z "$VERSION" ]; then
    echo "varible VERSION must be set!"
    exit 1
fi

CPU_COUNT=$(grep "processor" -c /proc/cpuinfo)
BUILDS=/emacs/debian

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
cp /lib/x86_64-linux-gnu/librt.so.1 $EMACSROOT/lib/
cp /lib/x86_64-linux-gnu/libtinfo.so.6 $EMACSROOT/lib/
cp /usr/lib/x86_64-linux-gnu/libgnutls.so.30 $EMACSROOT/lib/

# in the output we see that the binary is dynamically linking the
# files we copied
ldd $PREFIX/bin/emacs

mkdir -p $BUILDS

# make a tarball
(
    rm $BUILDS/emacs-${VERSION}.tar.gz || true
    cd $PREFIX

    tar czf $BUILDS/emacs-${VERSION}.tar.gz *
)

# make a .deb with fpm
(
    # set dependencies (check with apt)
    fpm -t deb -v $VERSION -n emacs -s dir $PREFIX/=/usr
    cp *.deb $BUILDS

)


exit 0
