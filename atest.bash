#~/bin/bash
echo "register" && \
sbcl --noinform \
     --eval '(ql:register-local-projects)' \
     --quit && \
echo "" && \
echo "compile" && \
echo "" && \
  sbcl  --noinform \
       --eval '(ql:quickload :arrowgrams/build :silent nil)' \
       --eval '(arrowgrams/build::arrowgrams-to-json "helloworld")' \
       --quit && \
echo "" && \
echo "run" && \
echo "" && \
  sbcl  --noinform \
       --eval '(ql:quickload :arrowgrams/runner :silent nil)' \
       --eval '(arrowgrams/build::load-and-run-from-file (arrowgrams/build::json-graph-path "helloworld"))' \
       --quit


# echo "quicklisp register" && \
# sbcl --noinform \
#      --eval '(uiop:run-program "~/quicklisp/local-projects/rm.bash")' \
#      --eval '(ql:register-local-projects)' \
#      --quit && \
# #  sbcl --noinform \
# echo "compile" && \
#   sbcl --noinform \
#        --eval '(uiop:run-program "~/quicklisp/local-projects/rm.bash")' \
#        --eval '(ql:quickload :arrowgrams/build :silent nil)' \
#        --eval '(arrowgrams/build::arrowgrams-to-json "helloworld")' \
#        --quit && \
# echo "run" && \
#   sbcl --noinform \
#        --eval '(uiop:run-program "~/quicklisp/local-projects/rm.bash")' \
#        --eval '(ql:quickload :arrowgrams/runner :silent nil)' \
#        --eval '(arrowgrams/build::load-and-run-from-file (arrowgrams/build::json-graph-path "helloworld"))' \
#        --quit

