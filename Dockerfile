FROM caddy:builder AS builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare

FROM caddy:alpine

RUN apk add --no-cache bash

COPY run.sh /run.sh
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD /run.sh
