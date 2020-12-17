#~/bin/bash
# usage: ./clrun.bash helloworld
sbcl  --noinform \
      --eval '(uiop:run-program "~/quicklisp/local-projects/rm.bash")' \
      --eval '(ql:register-local-projects)' \
      --eval '(ql:quickload :arrowgrams/runner :silent nil)' \
      --eval "(arrowgrams/build::load-and-run-from-file (arrowgrams/build::json-graph-path \"$1\"))" \
      --eval '(cl-user::dispatcher-inject *dispatcher* "start" t)' \
      --quit
