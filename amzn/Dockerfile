FROM amazonlinux:1

ARG VERSION=27.1
ARG CPU_COUNT=8
ARG PREFIX=/emacs/target

RUN yum -y update && \
    yum -y install devtoolset-9-gcc devtoolset-9-libgccjit-devel gnutls-devel git ncurses-devel && \
    yum -y groupinstall "Development Tools"

ADD emacs-${VERSION}.tar.xz /emacs
WORKDIR /emacs/emacs-${VERSION}

RUN ./configure --prefix=${PREFIX} --with-x=no CFLAGS="-I$ORIGIN/../include" --without-sound  \
       LDFLAGS="-L$ORIGIN/lib -Wl,-rpath=\\\$\$ORIGIN/../lib"
RUN make -j${CPU_COUNT}
RUN make install -j${CPU_COUNT}

ADD entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV VERSION ${VERSION}
ENV PREFIX ${PREFIX}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["package"]
