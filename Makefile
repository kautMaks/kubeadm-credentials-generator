DOCKER_BIN = docker
DOCKER_IMAGE = kaut/kubeadm-credentials-generator

all: clean build

build:
	${DOCKER_BIN} build . --file Dockerfile --tag ${DOCKER_IMAGE}:latest

clean:
	${DOCKER_BIN} images --quiet ${DOCKER_IMAGE} | xargs --no-run-if-empty ${DOCKER_BIN} rmi -f