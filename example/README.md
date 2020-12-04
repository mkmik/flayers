# example

## Try

```console
$ docker build -t example .
...
Successfully tagged example:latest
$ docker run --rm -ti example
foo
```

## What

This example shows how to add an immutable, content addressed layer to a docker image.

The example layer is very simple, it's just a single file with a shell script in it:

```console
$ curl -s ipfs.io/ipfs/QmcFRXYG3CriDWBaoMDmTV3SkjL9rhGSv7oyiatiQrteaF | tar tz
./
./foo
$ curl -s ipfs.io/ipfs/QmcFRXYG3CriDWBaoMDmTV3SkjL9rhGSv7oyiatiQrteaF | tar xzO
#!/bin/sh

echo foo
```

## How

The `Dockerfile` is a multi-stage build divided in two stages

* the first stage collects the layers by downloading them from IPFS
* the second stage is the actual image being built. You can inject layers referenced from the previous stage

```dockerfile
FROM mkmik/flayers as layers
RUN /layer1 ipfs/QmcFRXYG3CriDWBaoMDmTV3SkjL9rhGSv7oyiatiQrteaF

FROM bitnami/minideb

COPY --from=layers /layer1/ /

ENTRYPOINT [ "/foo" ]
```

Filesystem metadata including timestamps are preserved, and thus the layers have a reproducible digest.
