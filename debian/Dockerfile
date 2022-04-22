FROM debian:stable as base

ARG CPU_COUNT=8
ARG PREFIX=/emacs/target
ARG EMACS_UID=1337

ENV PREFIX=/emacs/target
ENV DEBIAN_FRONTEND=noninteractive

RUN useradd -m -d /emacs -u ${EMACS_UID} emacs
RUN apt-get update && apt-get -y install nettle-dev

WORKDIR /emacs

FROM base as builder

RUN apt-get update && \
    apt-get install -y wget build-essential autoconf texinfo gnutls-bin \
                       libgnutls28-dev pkg-config libncurses-dev patchelf \
                       libacl1-dev \
                       ruby ruby-dev rubygems build-essential git && \
                       gem install --no-document fpm


ARG VERSION
ENV VERSION=${VERSION}

COPY --chown=emacs:emacs emacs-src/ /emacs/emacs-src
USER emacs
WORKDIR /emacs/emacs-src
RUN mkdir /emacs/target

# --exec-prefix=$PREFIX
# --prefix=$PREFIX
RUN ./autogen.sh \
        && ./configure --with-x=no CFLAGS="-I$ORIGIN/include" LDFLAGS="-L$ORIGIN/lib -Wl,-rpath=\\\$\$ORIGIN/../lib" > /emacs/configure.log
RUN make -j${CPU_COUNT} > /emacs/make.log
RUN make install prefix=$PREFIX -j${CPU_COUNT} > /emacs/makeinstall.log

ARG DEBNAME=emacs
ADD debian/package.sh /usr/local/bin/package.sh
RUN /usr/local/bin/package.sh ${BUILD_MODE}

FROM base as final

ARG VERSION
ARG DEBNAME=emacs
ENV DEBNAME=${DEBNAME}

COPY --from=builder /emacs/debian/${DEBNAME}_${VERSION}_amd64.deb /
RUN dpkg -i /${DEBNAME}_${VERSION}_amd64.deb \
        && rm /${DEBNAME}_${VERSION}_amd64.deb

USER emacs
RUN /usr/local/bin/emacs --version
CMD ["/usr/local/bin/emacs"]
