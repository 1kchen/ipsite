FROM alpine AS downloader
RUN apk add --no-cache curl
RUN curl -L -o GeoLite2-ASN.mmdb https://git.io/GeoLite2-ASN.mmdb
RUN curl -L -o GeoLite2-City.mmdb https://git.io/GeoLite2-City.mmdb
RUN curl -L -o GeoLite2-Country.mmdb https://git.io/GeoLite2-Country.mmdb

FROM mpolden/echoip:latest
COPY --from=downloader /GeoLite2-ASN.mmdb /opt/echoip/GeoLite2-ASN.mmdb
COPY --from=downloader /GeoLite2-City.mmdb /opt/echoip/GeoLite2-City.mmdb
COPY --from=downloader /GeoLite2-Country.mmdb /opt/echoip/GeoLite2-Country.mmdb
COPY html /opt/echoip/html
WORKDIR /opt/echoip
ENTRYPOINT ["/opt/echoip/echoip"]
CMD ['-H','CF-Connecting-IP','-H','X-Forwarded-For','-a','GeoLite2-ASN.mmdb','-c','GeoLite2-City.mmdb','-f','GeoLite2-Country.mmdb']