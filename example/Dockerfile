FROM mkmik/flayers@sha256:8fa77c8f132c96aea1c899cdcfb463df0aefd8ec905ec998f92cd737fe233c88 as layers
RUN /layer1 ipfs/QmcFRXYG3CriDWBaoMDmTV3SkjL9rhGSv7oyiatiQrteaF

FROM bitnami/minideb@sha256:e158ab4d15b43b44aa48693d2d9f469da3676e7e44f178718983375cdb6d276c

COPY --from=layers /layer1/ /

ENTRYPOINT [ "/foo" ]
