# Use an alpine image
FROM alpine:3.23


# Install prerequisites
RUN apk update && \
    apk upgrade --no-cache && \
    apk add bash curl git ca-certificates yq


# Create a non-root user named alpine
RUN addgroup -g 1001 alpine && \
    adduser -u 1001 -G alpine -s /bin/bash -D alpine

 
# Give alpine user ownership/permissions for certificate directories
RUN chown -R alpine:alpine /usr/local/share/ca-certificates && \
    chown -R alpine:alpine /etc/ssl/certs && \
    chown alpine:alpine /etc/ca-certificates.conf && \
    chmod 755 /usr/local/share/ca-certificates && \
    chmod 755 /etc/ssl/certs

# Make update-ca-certificates accessible to alpine user
RUN chmod 755 /usr/sbin/update-ca-certificates