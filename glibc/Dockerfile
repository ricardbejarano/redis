FROM debian AS build

ARG REDIS_VERSION="5.0.5"
ARG REDIS_CHECKSUM="2139009799d21d8ff94fc40b7f36ac46699b9e1254086299f8d3b223ca54a375"

ADD http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz /tmp/redis.tar.gz

RUN cd /tmp && \
    if [ "$REDIS_CHECKSUM" != "$(sha256sum /tmp/redis.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar xf /tmp/redis.tar.gz && \
    mv /tmp/redis-$REDIS_VERSION /tmp/redis

RUN apt update && \
    apt install -y gcc make && \
    cd /tmp/redis && \
      make \
        CFLAGS="-fstack-protector-all" \
        LDFLAGS="-z relro -z now"


FROM scratch

COPY --from=build /lib/x86_64-linux-gnu/libc.so.6 \
                  /lib/x86_64-linux-gnu/libdl.so.2 \
                  /lib/x86_64-linux-gnu/libm.so.6 \
                  /lib/x86_64-linux-gnu/librt.so.1 \
                  /lib/x86_64-linux-gnu/libpthread.so.0 \
                  /lib/x86_64-linux-gnu/
COPY --from=build /lib64/ld-linux-x86-64.so.2 /lib64/
COPY --from=build /tmp/redis/redis.conf \
                  /tmp/redis/sentinel.conf \
                  /etc/redis/
COPY --from=build /tmp/redis/src/redis-server /

COPY rootfs /

WORKDIR /data
VOLUME ["/data"]
EXPOSE 6379/tcp
STOPSIGNAL SIGTERM
ENTRYPOINT ["/redis-server"]
