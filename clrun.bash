#~/bin/bash
echo "register" && \
sbcl --noinform \
     --eval '(uiop:run-program "~/quicklisp/local-projects/rm.bash")' \
     --eval '(ql:register-local-projects)' \
     --quit && \
 echo "" && \
 echo "run" && \
 echo "" && \
   sbcl  --noinform \
        --eval '(ql:quickload :arrowgrams/runner :silent nil)' \
	--eval '(format *standard-output* "running sbcl~%")' \
        --eval '(arrowgrams/build::load-and-run-from-file (arrowgrams/build::json-graph-path "helloworld"))' \
        --eval '(cl-user::dispatcher-inject *dispatcher* "start" t)' \
        --quit
