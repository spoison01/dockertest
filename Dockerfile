FROM alpine:latest AS builder
RUN apk add --no-cache curl unzip
# All-in-one download command to prevent URL truncation
RUN curl -L -H "Cache-Control: no-cache" -o xray.zip https://github.com && mkdir /xray_bin && unzip xray.zip -d /xray_bin

FROM alpine:latest
RUN apk add --no-cache ca-certificates mailcap && update-ca-certificates
WORKDIR /etc/xray
COPY --from=builder /xray_bin/xray /usr/bin/xray
COPY config.json /etc/xray/config.json
EXPOSE 343
CMD ["/usr/bin/xray", "run", "-config", "/etc/xray/config.json"]
