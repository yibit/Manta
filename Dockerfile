FROM golang:alpine as base

RUN set -ex \
	&& apk add --no-cache --virtual .fetch-deps \
	make

COPY . /go/src/manta

WORKDIR /go/src/manta

RUN set -ex \
    && export GOPATH=/go \
    && make build

FROM busybox

COPY --from=base /go/bin/manta /usr/local/bin/manta

EXPOSE 8080 

ENTRYPOINT [ "manta" ]

