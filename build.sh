#!/usr/bin/env bash

CURRENT_DIR="$(pwd)"
VERSION=0.1

docker build . --tag arrowgrams:${VERSION}
docker stop arrowgrams
docker rm --force arrowgrams
docker run --name=arrowgrams -v ${CURRENT_DIR}:/root/quicklisp/local-projects/bmfbp -p 8000:8000 arrowgrams:${VERSION}
