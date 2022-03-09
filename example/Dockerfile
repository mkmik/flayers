FROM mkmik/flayers@sha256:688c26414f46f5867b08f3bf29ddc08f33d9957938f71593333fd3d1977afb94 as layers
RUN /layer1 ipfs/QmcFRXYG3CriDWBaoMDmTV3SkjL9rhGSv7oyiatiQrteaF

FROM bitnami/minideb@sha256:e158ab4d15b43b44aa48693d2d9f469da3676e7e44f178718983375cdb6d276c

COPY --from=layers /layer1/ /

ENTRYPOINT [ "/foo" ]
