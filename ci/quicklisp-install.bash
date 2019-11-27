#!/usr/bin/env bash

DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

quicklisp=/tmp/quicklisp.lisp

wget https://beta.quicklisp.org/quicklisp.lisp --output-document ${quicklisp}

sbcl \
    --load ${quicklisp} \
    --eval '(quicklisp-quickstart:install)'  \
    --eval '(progn (setf ql-util::*do-not-prompt* t)(ql:add-to-init-file))' \
    --eval '(exit :code 0)'

  



