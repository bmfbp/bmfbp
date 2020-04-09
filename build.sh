#!/usr/bin/env bash

CURRENT_DIR="$(pwd)"
VERSION=0.1
PROJECT_ROOT="/root/quicklisp/local-projects/bmfbp"

PROGRAM_PATH=$(realpath "$1")

if [ ! -f "${PROGRAM_PATH}" ]; then
  >&2 echo "ERROR: Program at ${PROGRAM_PATH} must be an SVG file."
  exit 3
fi

docker build . --tag arrowgrams:${VERSION}
docker stop arrowgrams
docker rm --force arrowgrams
docker run \
  -dt \
  --name=arrowgrams \
  -v "${CURRENT_DIR}:${PROJECT_ROOT}" \
  -p 8000:8000 \
  -e "project_root=${PROJECT_ROOT}" \
  -e "program_path=${PROGRAM_PATH}" \
  arrowgrams:${VERSION}
