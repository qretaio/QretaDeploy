FROM alpine

# Create a non-root user
ARG USER_UID=1000
ARG USER_GID=1000

# Install dependencies
ARG KUBECTL_VERSION=v1.30.0
ENV HOME=/home/qreta
RUN apk add --no-cache \
    git \
    curl \
    openssh-client \
    ca-certificates \
    bash \
    && curl -L https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Create user with proper groups and home directory
RUN addgroup -g $USER_GID qreta && adduser -D -u $USER_UID -G qreta qreta
USER qreta
