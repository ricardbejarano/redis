<p align="center"><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/160/apple/198/balloon_1f388.png" width="120px"></p>
<h1 align="center">redis (container image)</h1>
<p align="center">Built-from-source container image of the <a href="https://redis.io/">Redis</a> in-memory data store</p>


## Tags

### Docker Hub

Available on Docker Hub as [`docker.io/ricardbejarano/redis`](https://hub.docker.com/r/ricardbejarano/redis):

- [`6.2.3`, `latest` *(Dockerfile)*](Dockerfile)

### RedHat Quay

Available on RedHat Quay as [`quay.io/ricardbejarano/redis`](https://quay.io/repository/ricardbejarano/redis):

- [`6.2.3`, `latest` *(Dockerfile)*](Dockerfile)


## Features

* Compiled from source during build time
* Built `FROM scratch`, with zero bloat
* Statically linked to the [`musl`](https://musl.libc.org/) implementation of the C standard library
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Runs as unprivileged (non-`root`) user


## Building

```bash
docker build --tag ricardbejarano/redis --file Dockerfile .
```


## Configuration

### Volumes

- Mount your **data** at `/data`.
- Mount your **configuration** at `/etc/redis/redis.conf`.


## License

MIT licensed, see [LICENSE](LICENSE) for more details.
