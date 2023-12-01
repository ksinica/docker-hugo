ARG ALPINE_VERSION=3.18
ARG GO_VERSION=1.21.4
ARG HUGO_VERSION=0.119.0

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder

ARG HUGO_VERSION
ENV CGO_ENABLED=1

RUN apk add --no-cache git gcc g++ musl-dev \
 && go install -v -tags extended github.com/gohugoio/hugo@v$HUGO_VERSION

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache ca-certificates libc6-compat libstdc++ git

COPY --from=builder /go/bin/hugo /usr/bin/hugo

WORKDIR /site

EXPOSE 1313

ENTRYPOINT ["/usr/bin/hugo"]
