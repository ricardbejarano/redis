FROM alpine:3 AS build

ARG VERSION="6.2.5"
ARG CHECKSUM="4b9a75709a1b74b3785e20a6c158cab94cf52298aa381eea947a678a60d551ae"

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
