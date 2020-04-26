#!/usr/bin/env bash

CURRENT_DIR="$(pwd)"
VERSION="0.1.1"
PROJECT_ROOT="/root/quicklisp/local-projects/bmfbp"
ARROWGRAMS_BRANCH="master"

PROGRAM_PATH="$1"

if [ ! -f "${PROGRAM_PATH}" ]; then
  >&2 echo "ERROR: Program at ${PROGRAM_PATH} must be an SVG file."
  exit 3
fi

# The program needs to be inside this directory
cp $PROGRAM_PATH __program

# Build the image
docker build . \
  --build-arg "build_mode=${BUILD_MODE}" \
  --build-arg "version=${VERSION}" \
  --build-arg "arrowgrams_branch=${ARROWGRAMS_BRANCH}" \
  --tag arrowgrams:${VERSION}

# Stop existing container, if any
docker stop arrowgrams
docker rm --force arrowgrams

# Run the container
docker run \
  --name=arrowgrams \
  -v "${CURRENT_DIR}:${PROJECT_ROOT}" \
  -e "project_root=${PROJECT_ROOT}" \
  -p 8000:8000 \
  arrowgrams:${VERSION}
