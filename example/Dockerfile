FROM mkmik/flayers@sha256:a4e842494e53328a9ed2b2b1ac73fb28d28ee51f8454c6ba8bdea9f2b37a57b9 as layers
RUN /layer1 ipfs/QmcFRXYG3CriDWBaoMDmTV3SkjL9rhGSv7oyiatiQrteaF

FROM bitnami/minideb@sha256:e158ab4d15b43b44aa48693d2d9f469da3676e7e44f178718983375cdb6d276c

COPY --from=layers /layer1/ /

ENTRYPOINT [ "/foo" ]
