FROM alpine:3 AS build

ARG VERSION="7.0.11"
ARG CHECKSUM="ce250d1fba042c613de38a15d40889b78f7cb6d5461a27e35017ba39b07221e3"

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
