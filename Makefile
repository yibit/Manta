VERSION    := $(shell cat ./VERSION |head -1)
IMAGE_NAME := manta

dep := $(GOPATH)/bin/dep

all: usage 

usage:
	@echo "Usage:                                              "
	@echo "                                                    "
	@echo "    make  command                                   "
	@echo "                                                    "
	@echo "The commands are:                                   "
	@echo "                                                    "
	@echo "    build       compile packages and dependencies   "
	@echo "    run         start the runner                    "
	@echo "    tests       run go test                         "
	@echo "    clean       remove object files                 "
	@echo "    fmt         run gofmt on package sources        "
	@echo "    docker      build the docker images             "
	@echo "    dep         run dep ensure                      "
	@echo "    update      run dep ensure -update              "
	@echo "    status      run dep status                      "
	@echo "    release     release a version                   "
	@echo "                                                    "


build:
	go install -v
	go build -o $(GOPATH)/bin/manta 

run: build
	$(GOPATH)/bin/manta

fmt:
	cd manta && go fmt

tests:
	cd manta && go test -v

prepare:
	go get -u github.com/golang/dep
	go get -u github.com/goreleaser/goreleaser

dep:
	$(dep) ensure

update:
	$(dep) ensure -update

status:
	$(dep) status -dot | dot -T png -o dep-status.png

docker:
	docker build -f Dockerfile -t manta-$(VERSION) .

release:
	git tag -a $(VERSION) -m "Release: $(VERSION)" || true
	git push origin $(VERSION)
	goreleaser --rm-dist

.PHONE: clean release fmt docker tests

clean:
	rm -f $(GOPATH)/bin/manta
	find . -name \*~ -type f |xargs -I {} rm -f {}

