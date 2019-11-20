#!/usr/bin/env bash

DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

dest=$HOME/.config/common-lisp/source-registry.conf.d

mkdir -p $HOME

# TODO figure out how to sanely address paths
echo '(:tree (:home "build/easye/bmfbp/"))' > ${dest}/bmfpb.conf

