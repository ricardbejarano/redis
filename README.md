<p align=center><img src=https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/160/apple/198/balloon_1f388.png width=120px></p>
<h1 align=center>redis (container image)</h1>
<p align=center>Built-from-source container image of the <a href=https://redis.io>Redis data structure store</a></p>


## Tags

### Docker Hub

Available on [Docker Hub](https://hub.docker.com) as [`ricardbejarano/redis`](https://hub.docker.com/r/ricardbejarano/redis):

- [`5.0.5-glibc`, `5.0.5`, `glibc`, `master`, `latest` *(glibc/Dockerfile)*](https://github.com/ricardbejarano/redis/blob/master/glibc/Dockerfile)
- [`5.0.5-musl`, `musl` *(musl/Dockerfile)*](https://github.com/ricardbejarano/redis/blob/master/musl/Dockerfile)

### Quay

Available on [Quay](https://quay.io) as:

- [`quay.io/ricardbejarano/redis-glibc`](https://quay.io/repository/ricardbejarano/redis-glibc), tags: [`5.0.5`, `master`, `latest` *(glibc/Dockerfile)*](https://github.com/ricardbejarano/redis/blob/master/glibc/Dockerfile)
- [`quay.io/ricardbejarano/redis-musl`](https://quay.io/repository/ricardbejarano/redis-musl), tags: [`5.0.5`, `master`, `latest` *(musl/Dockerfile)*](https://github.com/ricardbejarano/redis/blob/master/musl/Dockerfile)


## Features

* Super tiny (`glibc`-based is `~11.9MB` and `musl`-based is `~10.8MB`)
* Built from source
* Built `FROM scratch`, see the [Filesystem](#filesystem) section below for an exhaustive list of the image's contents
* Reduced attack surface (no `bash`, no UNIX tools, no package manager...)
* Built with exploit mitigations enabled (see [Security](#security))


## Configuration

### Volumes

- Bind your **data** at `/data`.
- Bind your **configuration** at `/etc/redis/redis.conf` and `/etc/redis/sentinel.conf`.


## Building

To build the `glibc`-based image:

```bash
docker build -t redis:glibc -f glibc/Dockerfile .
```

To build the `musl`-based image:

```bash
docker build -t redis:musl -f musl/Dockerfile .
```


## Security

This image attempts to build a secure Redis container image.

It does so by the following ways:

- downloading and verifying the source code of Redis and every library it is built with,
- packaging the image with only those files required during runtime (see [Filesystem](#filesystem)),
- by enforcing a series of exploit mitigations (PIE, full RELRO, full SSP, NX and Fortify)

### Verifying the presence of exploit mitigations

To check whether a binary in a container image has those mitigations enabled, use [tests/checksec.sh](https://github.com/ricardbejarano/redis/blob/master/tests/checksec.sh).

#### Usage

```
usage: checksec.sh docker_image executable_path

Container-based wrapper for checksec.sh.
Requires a running Docker daemon.

Example:

  $ checksec.sh ricardbejarano/redis:glibc /redis-server

  Extracts the '/redis-server' binary from the 'ricardbejarano/redis:glibc' image,
  downloads checksec (github.com/slimm609/checksec.sh) and runs it on the
  binary.
  Everything runs inside containers.
```

#### Example:

Testing the `/redis-server` binary in `ricardbejarano/redis:glibc`:

```
$ bash tests/checksec.sh ricardbejarano/redis:glibc /redis-server
Downloading ricardbejarano/redis:glibc...Done!
Extracting ricardbejarano/redis:glibc:/redis-server...Done!
Downloading checksec.sh...Done!
Running checksec.sh:
RELRO        STACK CANARY   NX           PIE           RPATH      RUNPATH      Symbols         FORTIFY   Fortified   Fortifiable   FILE
Full RELRO   Canary found   NX enabled   PIE enabled   No RPATH   No RUNPATH   4171 Symbols    Yes       0           42            /tmp/.checksec-aEFy5sb9
Cleaning up...Done!
```

This wrapper script works with any binary in a container image. Feel free to use it with any other image.

Other examples:

- `bash tests/checksec.sh debian /bin/bash`
- `bash tests/checksec.sh alpine /bin/sh`
- `bash tests/checksec.sh redis /usr/local/bin/redis-server`


## Filesystem

The images' contents are:

### `glibc`

Based on the [glibc](https://www.gnu.org/software/libc/) implementation of `libc`. Dynamically linked.

```
/
├── data/
├── etc/
│   ├── group
│   ├── passwd
│   └── redis/
│       ├── redis.conf
│       └── sentinel.conf
├── lib/
│   └── x86_64-linux-gnu/
│       ├── libc.so.6
│       ├── libdl.so.2
│       ├── libm.so.6
│       ├── libpthread.so.0
│       └── librt.so.1
├── lib64/
│   └── ld-linux-x86-64.so.2
└── redis-server
```

### `musl`

Based on the [musl](https://www.musl-libc.org/) implementation of `libc`. Dynamically linked.

```
/
├── data/
├── etc/
│   ├── group
│   ├── passwd
│   └── redis/
│       ├── redis.conf
│       └── sentinel.conf
├── lib/
│   └── ld-musl-x86_64.so.1
└── redis-server
```


## License

See [LICENSE](https://github.com/ricardbejarano/redis/blob/master/LICENSE).
