<p align="center"><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/160/apple/198/balloon_1f388.png" width="120px"></p>
<h1 align="center">redis (container image)</h1>
<p align="center">Built-from-source container image of the <a href="https://redis.io">Redis in-memory data structure store</a></p>


## Tags

### Docker Hub

Available on [Docker Hub](https://hub.docker.com) as [`ricardbejarano/redis`](https://hub.docker.com/r/ricardbejarano/redis):

- [`6.0.3-glibc`, `6.0.3`, `glibc`, `master`, `latest` *(Dockerfile.glibc)*](https://github.com/ricardbejarano/redis/blob/master/Dockerfile.glibc) (about `21.1MB`)
- [`6.0.3-musl`, `musl` *(Dockerfile.musl)*](https://github.com/ricardbejarano/redis/blob/master/Dockerfile.musl) (about `17.1MB`)

### Quay

Available on [Quay](https://quay.io) as:

- [`quay.io/ricardbejarano/redis`](https://quay.io/repository/ricardbejarano/redis), [`quay.io/ricardbejarano/redis-glibc`](https://quay.io/repository/ricardbejarano/redis-glibc), tags: [`6.0.3`, `master`, `latest` *(Dockerfile.glibc)*](https://github.com/ricardbejarano/redis/blob/master/Dockerfile.glibc) (about `21.1MB`)
- [`quay.io/ricardbejarano/redis-musl`](https://quay.io/repository/ricardbejarano/redis-musl), tags: [`6.0.3`, `master`, `latest` *(Dockerfile.musl)*](https://github.com/ricardbejarano/redis/blob/master/Dockerfile.musl) (about `17.1MB`)


## Features

* Super tiny (see [Tags](#tags))
* Compiled from source (with binary exploit mitigations) during build time
* Built `FROM scratch`, with zero bloat (see [Filesystem](#filesystem))
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Runs as unprivileged (non-`root`) user


## Configuration

### Volumes

- Mount your **data** at `/data`.
- Mount your **configuration** at `/etc/redis/redis.conf` and/or `/etc/redis/sentinel.conf`.


## Building

- To build the `glibc`-based image: `$ docker build -t redis:glibc -f Dockerfile.glibc .`
- To build the `musl`-based image: `$ docker build -t redis:musl -f Dockerfile.musl .`


## Filesystem

### `glibc`

Based on the [glibc](https://www.gnu.org/software/libc/) implementation of `libc`. Dynamically linked.

```
/
├── data/
├── etc/
│   ├── group
│   └── passwd
├── lib/
│   └── x86_64-linux-gnu/
│       ├── libc.so.6
│       ├── libdl.so.2
│       ├── libm.so.6
│       ├── libpthread.so.0
│       └── librt.so.1
├── lib64/
│   └── ld-linux-x86-64.so.2
├── redis-cli
└── redis-server
```

### `musl`

Based on the [musl](https://www.musl-libc.org/) implementation of `libc`. Dynamically linked.

```
/
├── data/
├── etc/
│   ├── group
│   └── passwd
├── lib/
│   └── ld-musl-x86_64.so.1
├── redis-cli
└── redis-server
```


## License

See [LICENSE](https://github.com/ricardbejarano/redis/blob/master/LICENSE).
