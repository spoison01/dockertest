# --- Stage 1: Download Xray ---
FROM alpine:latest AS builder

RUN apk add --no-cache curl unzip

# Using the direct, full URL to avoid variable errors
RUN curl -L -H "Cache-Control: no-cache" -o xray.zip \
    https://github.com \
    && mkdir /xray_bin \
    && unzip xray.zip -d /xray_bin

# --- Stage 2: Final Runtime Image ---
FROM alpine:latest

RUN apk add --no-cache ca-certificates mailcap && \
    update-ca-certificates

WORKDIR /etc/xray

COPY --from=builder /xray_bin/xray /usr/bin/xray
COPY config.json /etc/xray/config.json

# Port for your VLESS config
EXPOSE 343

CMD ["/usr/bin/xray", "run", "-config", "/etc/xray/config.json"]
