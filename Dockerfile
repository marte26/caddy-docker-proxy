FROM caddy:2.7.3-builder AS builder

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2@v2.8.4 \
    --with github.com/caddy-dns/cloudflare
    
FROM caddy:2.7.3

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

CMD ["caddy", "docker-proxy"]
