FROM debian:bullseye

ARG VERSION=27.1
ARG CPU_COUNT=8
ARG PREFIX=/emacs/target

ENV VERSION ${VERSION}
ENV PREFIX ${PREFIX}
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /emacs/target && \
    apt-get update && \
    apt-get install -y wget build-essential autoconf texinfo gnutls-bin \
                       libgnutls28-dev pkg-config libncurses-dev patchelf \
                       ruby ruby-dev rubygems build-essential && \
                       gem install --no-document fpm

# untars !
ADD emacs-${VERSION}.tar.xz /emacs
WORKDIR /emacs/emacs-${VERSION}

RUN ./configure --prefix=$PREFIX --with-x=no CFLAGS="-I$ORIGIN/include" \
       LDFLAGS="-L$ORIGIN/lib -Wl,-rpath=\\\$\$ORIGIN/../lib"
RUN make -j${CPU_COUNT}
RUN make install -j${CPU_COUNT}

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["package"]
