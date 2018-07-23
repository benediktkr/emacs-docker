FROM alpine:3.8


RUN addgroup -S emacs && \
    adduser -S -G emacs emacs && \
    mkdir /outside && \
    chown -R emacs:emacs /outside && \
    chown -R emacs:emacs /home/emacs
WORKDIR /outside
RUN apk add --no-cache ca-certificates emacs
COPY ./.emacs /home/emacs/.emacs
RUN chown emacs:emacs /home/emacs/.emacs
USER emacs
#ADD --chown=emacs:emacs ./.emacs /home/emacs/.emacs
RUN emacs -batch -l /home/emacs/.emacs

ENTRYPOINT ["emacs"]
