#~/bin/bash
sbcl --noinform \
     --eval '(uiop:run-program "~/quicklisp/local-projects/rm.bash")' \
     --eval '(ql:register-local-projects)' \
     --quit && \
  sbcl --noinform \
       --eval '(uiop:run-program "~/quicklisp/local-projects/rm.bash")' \
       --eval '(ql:quickload :arrowgrams/build :silent t)' \
       --eval '(arrowgrams/build::arrowgrams-to-json "helloworld")' \
       --eval '(ql:quickload :arrowgrams/runner :silent t)' \
       --eval '(arrowgrams/build::load-and-run-from-file (arrowgrams/build::json-graph-path "helloworld"))' \
       --quit

