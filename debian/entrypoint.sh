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
cp /lib/x86_64-linux-gnu/librt.so.1 $EMACSROOT/lib/
cp /lib/x86_64-linux-gnu/libtinfo.so.6 $EMACSROOT/lib/
cp /usr/lib/x86_64-linux-gnu/libgnutls.so.30 $EMACSROOT/lib/

# in the output we see that the binary is dynamically linking the
# files we copied
ldd $TARGET/bin/emacs

mkdir -p $DIST/debian

# make a tarball
(
    rm $DIST/debian/emacs-${VERSION}.tar.gz || true
    cd $TARGET

    tar -cf $DIST/debian/emacs-${VERSION}.tar.gz .
)

# make a .deb with fpm
(
    # set dependencies (check with apt)
    fpm -t deb -v $VERSION -n emacs -s dir $TARGET/=/usr
    cp *.deb $DIST/debian/

)

# copy the compiled $TARGET
(
    rm -rf $DIST/debian/emacs-${VERSION} || true
    mkdir -p $DIST/debian/emacs-${VERSION}
    cp -r $TARGET/* $DIST/debian/emacs-${VERSION}/
)




# if [ ! -d "/emacs/emacs-${VERSION}" ]; then
#     (
#         cd /emacs
#         wget https://ftp.gnu.org/gnu/emacs/emacs-${VERSION}.tar.xz
#         tar xf emacs-${VERSION}.tar.xz
#         rm emacs-${VERSION}.tar.xz
#         # todo: check signature
#     )
# fi
