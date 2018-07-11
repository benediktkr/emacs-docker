# xenial becaues it hsa libgnutls-dev
#FROM ubuntu:xenial
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y git build-essential autoconf libncurses-dev # libgnutls-dev

RUN mkdir /build /emacs
WORKDIR /build/emacs
RUN git clone --depth 1 https://github.com/emacs-mirror/emacs.git /build/emacs
RUN ./autogen.sh && \
    ./configure --without-x --without-makeinfo --without-gnutls --prefix=/emacs && \
    make && \
    make install
WORKDIR /emacs
RUN rm -rf /build
ENTRYPOINT ["/emacs/bin/emacs"]
