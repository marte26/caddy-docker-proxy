FROM docker.io/library/golang:1.25.7 AS build

WORKDIR /app
COPY go.mod go.sum main.go ./
RUN go mod download && CGO_ENABLED=0 go build -ldflags "-s -w" -o /caddy

FROM scratch

LABEL org.opencontainers.image.version=v2.10.2
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/marte26/caddy-docker-proxy"

ENV XDG_CONFIG_HOME=/config XDG_DATA_HOME=/data
VOLUME [ "/config", "/data" ]

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp

COPY --from=build /caddy /caddy

ENTRYPOINT [ "/caddy" ]
CMD [ "docker-proxy" ]
