#!/usr/bin/env bash

CURRENT_DIR="$(pwd)"
VERSION=0.1
PROJECT_ROOT="/root/quicklisp/local-projects/bmfbp"
ARROWGRAMS_BRANCH="pt-20200106-dockerized"

PROGRAM_PATH="$1"

if [ ! -f "${PROGRAM_PATH}" ]; then
  >&2 echo "ERROR: Program at ${PROGRAM_PATH} must be an SVG file."
  exit 3
fi

set -x

docker build . \
  --build-arg "build_mode=${BUILD_MODE}" \
  --build-arg "program_path=${PROGRAM_PATH}" \
  --build-arg "version=${VERSION}" \
  --build-arg "arrowgrams_branch=${ARROWGRAMS_BRANCH}" \
  --tag arrowgrams:${VERSION}
docker stop arrowgrams
docker rm --force arrowgrams
docker run \
  -dt \
  --name=arrowgrams \
  -v "${CURRENT_DIR}:${PROJECT_ROOT}" \
  -e "project_root=${PROJECT_ROOT}" \
  -p 8000:8000 \
  arrowgrams:${VERSION}
