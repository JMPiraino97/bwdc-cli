# Using Ubuntu image
FROM ubuntu:24.04

ENV DEBIAN FRONTEND=noninteractive
ENV BW_APP_DATA=/home/ubuntu/.config/'Bitwarden Directory Connector'/
# Installing libraries and dependencies
RUN apt-get update && apt-get install -y \
curl \
unzip \
libsecret-1-0 \
libatomic1 \
dbus-x11 --no-install-recommends \
ca-certificates \
&& rm -rf /var/lib/apt/lists/*

# Creating non-root user and groups to harden image
RUN groupadd -g 1001 bwdc \
    && useradd -u 1001 -g 1001 --create-home --shell /bin/bash bwdc \
    && mkdir -p ${BW_APP_DATA} \ 
    && chown -R 1001:1001 /home/bwdc \
    && chown -R 1001:1001 /etc/ssl/certs && \
    && chmod 755 /etc/ssl/certs

ENV BWDC_VERSION=2026.6.1
# Using curl to download the CLI and placing it in usr/local/bin. Also giving the CLI executable permissions
RUN curl -L -o /tmp/bwdc.zip "https://github.com/bitwarden/directory-connector/releases/download/v${BWDC_VERSION}/bwdc-linux-${BWDC_VERSION}.zip" \
    && unzip /tmp/bwdc.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/bwdc \
    && rm /tmp/bwdc.zip

# Set working directory for the data file
USER 1001:1001
WORKDIR /home/ubuntu/.config/'Bitwarden Directory Connector'/
ENTRYPOINT ["bwdc"]