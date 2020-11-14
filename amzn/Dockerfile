FROM amazonlinux:1

ARG VERSION=27.1
ARG CPU_COUNT=8

RUN yum -y update && \
    yum -y install devtoolset-9-gcc devtoolset-9-libgccjit-devel gnutls-devel git ncurses-devel && \
    yum -y groupinstall "Development Tools"

ADD emacs-${VERSION}.tar.xz /emacs
WORKDIR /emacs/emacs-${VERSION}
ARG PREFIX=/emacs/target

RUN ./configure --prefix=${PREFIX} --with-x=no CFLAGS="-I$ORIGIN/../include" --without-sound  \
       LDFLAGS="-L$ORIGIN/lib -Wl,-rpath=\\\$\$ORIGIN/../lib"
RUN make -j${CPU_COUNT}
RUN make install -j${CPU_COUNT}

ADD entrypoint-amzn.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint-amzn.sh

ENV VERSION ${VERSION}
ENV PREFIX ${PREFIX}

ENTRYPOINT ["/usr/local/bin/entrypoint-amzn.sh"]
CMD ["package"]
