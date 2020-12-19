FROM debian:bullseye

ENV DEBIAN_FRONTEND noninteractive
ARG VERSION=27.1
ARG CPU_COUNT=8

RUN mkdir /emacs && mkdir /emacs/target && mkdir /emacs/build/ && \
    apt-get update && \
    apt-get install -y wget build-essential autoconf texinfo gnutls-bin \
                       libgnutls28-dev pkg-config libncurses-dev patchelf \
                       ruby ruby-dev rubygems build-essential && \
                       gem install --no-document fpm	

# untars !
ADD emacs-${VERSION}.tar.xz /emacs
WORKDIR /emacs/emacs-${VERSION}
ARG PREFIX=/emacs/target

RUN ./configure --prefix=$PREFIX --with-x=no CFLAGS="-I$EMACSROOT/include" \
       LDFLAGS="-L$EMACSROOT/lib -Wl,-rpath=\\\$\$ORIGIN/../lib"
RUN make -j${CPU_COUNT}
RUN make install -j${CPU_COUNT}

ADD entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV VERSION ${VERSION}
ENV PREFIX ${PREFIX}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["package"]
