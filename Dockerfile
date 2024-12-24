FROM rust:1.83.0-alpine3.21

LABEL "name"="Automate publishing Rust build artifacts for GitHub releases through GitHub Actions"
LABEL "version"="1.4.6"
LABEL "repository"="http://github.com/k12u/rust-build.action"
LABEL "maintainer"="k12u <k12u@users.noreply.github.com>"

# Add regular dependencies
RUN apk add --no-cache curl jq git build-base bash zip tar xz zstd upx

# Add windows dependencies
RUN apk add --no-cache mingw-w64-gcc

# Add apple dependencies
RUN apk add --no-cache clang cmake libxml2-dev openssl-dev musl-fts-dev bsd-compat-headers
RUN git clone https://github.com/tpoechtrager/osxcross /opt/osxcross
RUN curl -Lo /opt/osxcross/tarballs/MacOSX10.10.sdk.tar.xz "https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz"
RUN ["/bin/bash", "-c", "cd /opt/osxcross && UNATTENDED=yes OSX_VERSION_MIN=10.8 ./build.sh"]

COPY entrypoint.sh /entrypoint.sh
COPY build.sh /build.sh
COPY common.sh /common.sh

RUN chmod 555 /entrypoint.sh /build.sh /common.sh

ENTRYPOINT ["/entrypoint.sh"]
