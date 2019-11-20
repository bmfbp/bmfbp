#!/usr/bin/env bash

DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

dest=$HOME/.config/common-lisp/source-registry.conf.d

mkdir -p $HOME

# Locate the root of the source repository
bmfbp=${TRAVIS_BUILD_DIR}

# TODO figure out how to sanely address paths
echo '(:tree "${bmfbp}")' > ${dest}/bmfpb.conf

