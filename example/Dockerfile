FROM mkmik/flayers as layers
RUN /layer1 ipfs/QmcFRXYG3CriDWBaoMDmTV3SkjL9rhGSv7oyiatiQrteaF

FROM bitnami/minideb

COPY --from=layers /layer1/ /

ENTRYPOINT [ "/foo" ]
