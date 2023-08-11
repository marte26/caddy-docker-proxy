FROM golang:1.20-alpine as build

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 go build -ldflags "-s -w" -o /caddy

FROM gcr.io/distroless/static AS final

LABEL org.opencontainers.image.version=v2.7.3
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://git.badsl.nl/marte26/caddy-docker-proxy"

ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp

COPY --from=build --chown=nonroot:nonroot /caddy /caddy

CMD ["/caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
