FROM debian:bullseye as base

ARG VERSION=27.1
ARG CPU_COUNT=8
ARG PREFIX=/emacs/target

ENV VERSION=${VERSION}
ENV PREFIX=${PREFIX}
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /emacs/target && \
    apt-get update && \
    apt-get install -y wget build-essential autoconf texinfo gnutls-bin \
                       libgnutls28-dev pkg-config libncurses-dev patchelf \
                       ruby ruby-dev rubygems build-essential git && \
                       gem install --no-document fpm


FROM base as builder
ADD emacs-src/ /emacs/emacs-${VERSION}
WORKDIR /emacs/emacs-${VERSION}

RUN ./autogen.sh \
        && ./configure --prefix=$PREFIX --with-x=no CFLAGS="-I$ORIGIN/include" LDFLAGS="-L$ORIGIN/lib -Wl,-rpath=\\\$\$ORIGIN/../lib"
RUN make -j${CPU_COUNT}
RUN make install -j${CPU_COUNT}

ADD debian/package.sh /usr/local/bin/package.sh
RUN chmod +x /usr/local/bin/package.sh
RUN /usr/local/bin/package.sh
RUN rm -rf /emacs/emacs-${VERSION}

FROM builder as final
RUN dpkg -i /emacs/debian/emacs_27.1_amd64.deb \
        && rm -rf /emacs/debian
RUN /usr/bin/emacs --version

CMD ["/usr/bin/emacs"]
