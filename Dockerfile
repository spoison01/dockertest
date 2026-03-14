# Use the official Xray image directly
FROM teddysun/xray:latest

# Set the working directory
WORKDIR /etc/xray

# Copy your local config.json into the container
# Ensure config.json is in the same folder as this Dockerfile on GitHub
COPY config.json /etc/xray/config.json

# Matches your config port
EXPOSE 443

# Run Xray
CMD ["/usr/bin/xray", "run", "-config", "/etc/xray/config.json"]
