############################
# STEP 1 build executable binary
############################
FROM golang:1.15-alpine3.12 AS builder
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git=2.26.3-r0 ca-certificates=20191127-r4

WORKDIR $GOPATH/src/devops-page/
COPY . .
ARG
# Fetch dependencies using go get
RUN go get -d -v
# Build the binary.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /root/devops-page/devops-page
COPY ./views /root/devops-page/views
COPY ./routes /root/devops-page/routes
COPY ./public /root/devops-page/public

############################
# STEP 2 build a small image
############################
FROM scratch
ARG APP_VERSION="0.0.1"
ENV APP_VERSION=${APP_VERSION}
LABEL maintainer="dlavrushko@protonmail.com"
WORKDIR /app/
COPY --from=builder /root/devops-page/ .

ENTRYPOINT ["/app/devops-page"]