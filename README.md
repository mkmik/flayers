# flayers

Hack to "declaratively" compose layers via an imperative dockerfile and a little DSL. Written in rust.

See [example](./example)

```
FROM mkmik/flayers@sha256:ed549771fc2aaaa7b36edd0f9481c7333357a87f5c1602ffb8e8d12ccc60eed6 as layers
RUN /layer1 ipfs/QmcFRXYG3CriDWBaoMDmTV3SkjL9rhGSv7oyiatiQrteaF

FROM bitnami/minideb@sha256:e158ab4d15b43b44aa48693d2d9f469da3676e7e44f178718983375cdb6d276c

COPY --from=layers /layer1/ /

ENTRYPOINT [ "/foo" ]
```
