APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=stanislavstarodub
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux#Linux darwin windows
TARGETARCH=amd64#arm64 amd64
PATHNAME=$(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/StanislavStarodub/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH)
	docker build . -t ghcr.io/$(PATHNAME)

push:
	docker push $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH)
	docker push ghcr.io/$(PATHNAME)

clean:
	rm -rf kbot
	docker rmi $(REGISTRY)/$(APP):$(VERSION)-$(TARGETARCH)
	docker rmi ghcr.io/$(PATHNAME)
