FROM debian AS build

ARG REDIS_VERSION="5.0.5"
ARG REDIS_CHECKSUM="2139009799d21d8ff94fc40b7f36ac46699b9e1254086299f8d3b223ca54a375"

ADD http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz /tmp/redis.tar.gz

RUN if [ "$REDIS_CHECKSUM" != "$(sha256sum /tmp/redis.tar.gz | awk '{print $1}')" ]; then exit 1; fi && \
    tar -C /tmp -xf /tmp/redis.tar.gz && \
    mv /tmp/redis-$REDIS_VERSION /tmp/redis

RUN apt update && \
    apt install -y gcc make && \
    cd /tmp/redis && \
      # see https://github.com/docker-library/redis/blob/6845f6d4940f94c50a9f1bf16e07058d0fe4bc4f/5.0/Dockerfile#L59
      grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 1$' src/server.h; \
      sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' src/server.h; \
      grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 0$' src/server.h; \
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
COPY --from=build /tmp/redis/src/redis-server /

COPY --chown=100:100 rootfs /

USER redis:redis
WORKDIR /data
VOLUME ["/data"]
EXPOSE 6379/tcp
ENTRYPOINT ["/redis-server"]
