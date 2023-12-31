APP=$(shell basename $(shell git remote get-url origin))
REGISTRY_DOCKER=stanislavstarodub/$(APP)
REGISTRY_GH=stanislavstarodub/$(APP)
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux#Linux darwin windows
TARGETARCH=amd64#arm64 amd64
PATHNAME_DOCKER=$(REGISTRY_DOCKER):$(VERSION)-$(TARGETOS)-$(TARGETARCH)
PATHNAME_GH=$(REGISTRY_GH):$(VERSION)-$(TARGETOS)-$(TARGETARCH)

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
	docker build . -t $(PATHNAME_DOCKER)
	#docker build . -t ghcr.io/$(PATHNAME_GH)

push:
	docker push $(PATHNAME_DOCKER)
	#docker push ghcr.io/$(PATHNAME_GH)

clean:
	rm -rf kbot
	docker rmi $(PATHNAME_DOCKER)
	#docker rmi ghcr.io/$(PATHNAME_GH)
