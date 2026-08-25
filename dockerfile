# Using Ubuntu image
FROM ubuntu:24.04

# Defining environmental variables needed for the directory connector to function (Having BWDC to read the secrets as plaintext so there is no need to store secrets in the linux keyring)
ENV DEBIAN FRONTEND=noninteractive
ENV BITWARDEN_CLI_CONNECTOR_PLAINTEXT_SECRETS=true
ENV NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
ENV BITWARDENCLI_CONNECTOR_APPDATA_DIR=/home/ubuntu/.config/'Bitwarden Directory Connector'/

# Installing libraries and dependencies
RUN apt-get update && apt-get install -y \
curl \
unzip \
libsecret-1-0 \
libatomic1 \
dbus-x11 --no-install-recommends \
ca-certificates \
&& rm -rf /var/lib/apt/lists/*

ENV BWDC_VERSION=2026.6.1
# Using curl to download the CLI and placing it in usr/bin/local. Also giving the CLI executable permissions
RUN curl -L -o /tmp/bwdc.zip "https://github.com/bitwarden/directory-connector/releases/download/v${BWDC_VERSION}/bwdc-linux-${BWDC_VERSION}.zip" \
    && unzip /tmp/bwdc.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/bwdc \
    && rm /tmp/bwdc.zip

# Creating directory for the data file
RUN mkdir -p /home/ubuntu/.config/'Bitwarden Directory Connector'/
WORKDIR /home/ubuntu/.config/'Bitwarden Directory Connector'/
ENTRYPOINT ["bwdc"]