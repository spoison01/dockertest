# --- Stage 1: Download and verify Xray ---
FROM alpine:latest AS builder

# Set Xray version (or use 'latest')
ARG XRAY_VERSION=latest

RUN apk add --no-cache curl unzip

# Download the Xray-core binary for Linux 64-bit
RUN curl -L -H "Cache-Control: no-cache" -o xray.zip \
    https://github.com{XRAY_VERSION}/download/Xray-linux-64.zip \
    && mkdir /xray_bin \
    && unzip xray.zip -d /xray_bin

# --- Stage 2: Final Runtime Image ---
FROM alpine:latest

# Install CA certificates for outbound TLS connections (Required for 'freedom' protocol)
RUN apk add --no-cache ca-certificates mailcap && \
    update-ca-certificates

WORKDIR /etc/xray

# Copy the binary from the builder stage
COPY --from=builder /xray_bin/xray /usr/bin/xray

# Copy your local config.json into the container
COPY config.json /etc/xray/config.json

# Expose the port from your config (Port 343)
EXPOSE 443

# Start Xray and point to the config
CMD ["/usr/bin/xray", "run", "-config", "/etc/xray/config.json"]
