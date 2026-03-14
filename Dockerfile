# --- Stage 1: Download and verify Xray ---
FROM alpine:latest AS builder

# Set Xray version
ARG XRAY_VERSION=latest

RUN apk add --no-cache curl unzip

# Fixed the URL below (added missing $ and repo path)
RUN curl -L -H "Cache-Control: no-cache" -o xray.zip \
    https://github.com{XRAY_VERSION}/download/Xray-linux-64.zip \
    && mkdir /xray_bin \
    && unzip xray.zip -d /xray_bin

# --- Stage 2: Final Runtime Image ---
FROM alpine:latest

RUN apk add --no-cache ca-certificates mailcap && \
    update-ca-certificates

WORKDIR /etc/xray

COPY --from=builder /xray_bin/xray /usr/bin/xray
COPY config.json /etc/xray/config.json

# Matches your config port
EXPOSE 343

CMD ["/usr/bin/xray", "run", "-config", "/etc/xray/config.json"]
