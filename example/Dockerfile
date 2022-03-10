FROM mkmik/flayers@sha256:ce6168cf594770a8ca67e27c86c0116f53301e7edbcf0d3e3b3ef2b94df82d7b as layers
RUN /layer1 ipfs/QmcFRXYG3CriDWBaoMDmTV3SkjL9rhGSv7oyiatiQrteaF

FROM bitnami/minideb@sha256:e158ab4d15b43b44aa48693d2d9f469da3676e7e44f178718983375cdb6d276c

COPY --from=layers /layer1/ /

ENTRYPOINT [ "/foo" ]
