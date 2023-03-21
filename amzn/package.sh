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

# librt
cp -L  /lib64/librt.so.1 $PREFIX/lib/
cp /lib64/librt-2.26.so $PREFIX/lib/

# libgnutls
cp -L /usr/lib64/libgnutls.so.28 $PREFIX/lib/
cp -L /usr/lib64/libgnutls.so $PREFIX/lib/
cp -L /usr/lib64/libgnutls.so.28 $PREFIX/lib/
cp /usr/lib64/libgnutls.so.28.43.3 $PREFIX/lib/

# libtasn
cp -L /usr/lib64/libtasn1.so.6 $PREFIX/lib/
cp -L /usr/lib64/libtasn1.so $PREFIX/lib/
cp /usr/lib64/libtasn1.so.6.5.3 $PREFIX/lib/

# linux-vdso.so.1 $PREFIX/lib/

# in the output we see that the binary is dynamically linking the
# files we copied
ldd $PREFIX/bin/emacs


mkdir -p $BUILDS

# # compile kvdo to get the linux-vdso.so.1 lib file that emacs needs
# (
#     find / -name "linux-vdso.so.1"
#     cd /emacs/kvdo
#     KERNEL=$(ls /usr/src/kernels)
#     make -C /usr/src/kernels/${KERNEL} M=/emacs/kvdo
#     make -C /usr/src/kernels/${KERNEL} M=/emacs/kvdo  modules_install

#     echo "done"
#     exit 1
# )

# make a tarball
(
    rm $BUILDS/czemacs-${VERSION}.tar.gz || true

    cd $PREFIX
    tar -czf $BUILDS/czemacs-${VERSION}.tar.gz *
)
