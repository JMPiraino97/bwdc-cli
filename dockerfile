# Using Ubuntu image
FROM ubuntu:22.04

# Defining environmental variables needed for the directroy connector to function (Having BWDC to read the secrets as plaintext so there is no need to store secrets in the linux keyring)
ENV DEBIAN FRONTEND=noninteractive
ENV BITWARDEN_CLI_CONNECTOR_PLAINTEXT_SECRETS=true
ENV BITWARDENCLI_CONNECTOR_APPDATA_DIR=/home/ubuntu/.config/'Bitwarden Directory Connector'/
ENV NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt 

# Installing dependencies
RUN apt-get update && apt-get install -y \
curl \
unzip \
libsecret-1-0 \
ca-certificates \
&& rm -rf /var/lib/apt/lists/*

# moving files to appropriate directory and ensuring executable permissions
COPY bwdc dc_native.linux-x64-gnu.node /usr/local/bin/
RUN chmod +x usr/local/bin/bwdc 
RUN mkdir -p /home/ubuntu/.config/'Bitwarden Directory Connector'/
WORKDIR /home/ubuntu/.config/'Bitwarden Directory Connector'/
ENTRYPOINT ["bwdc"]
