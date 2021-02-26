#!/bin/bash

set -e
set -x

if [ -z "$VERSION" ]; then
    echo "varible VERSION must be set!"
    exit 1
fi

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

echo $PREFIX

# copying some lib files
cp /lib/x86_64-linux-gnu/librt.so.1 $PREFIX/lib/
cp /lib/x86_64-linux-gnu/libtinfo.so.6 $PREFIX/lib/
cp /usr/lib/x86_64-linux-gnu/libgnutls.so.30 $PREFIX/lib/

# might not work on ubuntu
cp /usr/lib/x86_64-linux-gnu/libnettle.so.8 $PREFIX/lib/
cp /usr/lib/x86_64-linux-gnu/libhogweed.so.6 $PREFIX/lib/

# shown as inlcuded by ldd but havent been needed so far
# cp /lib/x86_64-linux-gnu/libanl.so.1 $PREFIX/lib/
# cp /lib/x86_64-linux-gnu/libm.so.6 $PREFIX/lib/
# cp /lib/x86_64-linux-gnu/libdl.so.2 $PREFIX/lib/
# cp /usr/lib/x86_64-linux-gnu/libgmp.so.10 $PREFIX/lib/
# cp /lib/x86_64-linux-gnu/libc.so.6 $PREFIX/lib/
# cp /usr/lib/x86_64-linux-gnu/libp11-kit.so.0 $PREFIX/lib/
# cp /usr/lib/x86_64-linux-gnu/libidn2.so.0 $PREFIX/lib/
# cp /usr/lib/x86_64-linux-gnu/libunistring.so.2 $PREFIX/lib/
# cp /usr/lib/x86_64-linux-gnu/libtasn1.so.6 $PREFIX/lib/
# cp /usr/lib/x86_64-linux-gnu/libnettle.so.8 $PREFIX/lib/


# pretty this one isnt needed since it should def be anywhere
# but included here because its show in the output of ldd
# /lib/x86_64-linux-gnu/libpthread.so.0

# in the output we see that the binary is dynamically linking the
# files we copied
ldd $PREFIX/bin/emacs

mkdir -p $BUILDS

# make a tarball
(
    cd $PREFIX

    tar czf $BUILDS/emacs-${VERSION}.tar.gz *
)

# make a .deb with fpm
(
    # set dependencies (check with apt)

    DEPENDS="-d nettle-dev"
    #DEPENDS=""
    fpm -t deb -v ${VERSION} -n emacs $DEPENDS -s dir $PREFIX/=/usr/local
    cp *.deb $BUILDS

)


exit 0
