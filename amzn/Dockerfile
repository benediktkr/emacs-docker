FROM amazonlinux:1

ARG VERSION=27.1
ARG CPU_COUNT=8
ARG PREFIX=/emacs/target

RUN yum -y update && \
    yum -y install devtoolset-9-gcc devtoolset-9-libgccjit-devel gnutls-devel git ncurses-devel && \
    yum -y groupinstall "Development Tools"

ADD emacs-src/ /emacs/emacs-${VERSION}
WORKDIR /emacs/emacs-${VERSION}

RUN ./autogen.sh && \
        ./configure --prefix=${PREFIX} --with-x=no CFLAGS="-I$ORIGIN/../include" --without-sound LDFLAGS="-L$ORIGIN/lib -Wl,-rpath=\\\$\$ORIGIN/../lib"
RUN make -j${CPU_COUNT}
RUN make install -j${CPU_COUNT}

ENV VERSION ${VERSION}
ENV PREFIX ${PREFIX}

ADD amzn/package.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/package.sh
RUN /usr/local/bin/package.sh

RUN rm -rf /emacs/emacs-${VERSION}
RUN ${PREFIX}/bin/emacs --version

CMD ["${PREFIX}/bin/emacs"]
