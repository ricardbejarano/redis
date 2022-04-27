FROM alpine:3 AS build

ARG VERSION="6.2.7"
ARG CHECKSUM="b7a79cc3b46d3c6eb52fa37dde34a4a60824079ebdfb3abfbbfa035947c55319"

ADD http://download.redis.io/releases/redis-$VERSION.tar.gz /tmp/redis.tar.gz

RUN [ "$(sha256sum /tmp/redis.tar.gz | awk '{print $1}')" = "$CHECKSUM" ] && \
    apk add gcc linux-headers make musl-dev pkgconf && \
    tar -C /tmp -xf /tmp/redis.tar.gz && \
    cd /tmp/redis-$VERSION && \
      make LDFLAGS="-static" MALLOC="libc"

RUN mkdir -p /rootfs/bin && \
      cp /tmp/redis-$VERSION/src/redis-benchmark /rootfs/bin/ && \
      cp /tmp/redis-$VERSION/src/redis-cli /rootfs/bin/ && \
      cp /tmp/redis-$VERSION/src/redis-server /rootfs/bin/ && \
    mkdir -p /rootfs/data && \
    mkdir -p /rootfs/etc && \
      echo "nogroup:*:10000:nobody" > /rootfs/etc/group && \
      echo "nobody:*:10000:10000:::" > /rootfs/etc/passwd


FROM scratch

COPY --from=build --chown=10000:10000 /rootfs /

USER 10000:10000
WORKDIR /data
VOLUME ["/data"]
EXPOSE 6379/tcp
ENTRYPOINT ["/bin/redis-server"]
CMD ["--protected-mode", "no"]
