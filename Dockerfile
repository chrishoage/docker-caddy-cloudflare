ARG CADDY_VERSION="2.6.4"

FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare

FROM caddy:${CADDY_VERSION}

RUN apk add --no-cache bash

# set version for s6 overlay
ARG OVERLAY_VERSION="v2.2.0.3"
ARG OVERLAY_ARCH="amd64"

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}-installer /tmp/
RUN chmod +x /tmp/s6-overlay-${OVERLAY_ARCH}-installer && /tmp/s6-overlay-${OVERLAY_ARCH}-installer / && rm /tmp/s6-overlay-${OVERLAY_ARCH}-installer


ENV CADDY_ARGS=""

COPY root/ /
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ENTRYPOINT ["/init"]
