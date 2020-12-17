#~/bin/bash
# usage: ./svg2json helloworld
echo "register" && \
sbcl --noinform \
     --eval '(uiop:run-program "~/quicklisp/local-projects/rm.bash")' \
     --eval '(ql:register-local-projects)' \
     --quit && \
echo "" && \
echo "compile" && \
echo "" && \
  sbcl  --noinform \
       --eval '(ql:quickload :arrowgrams/build :silent nil)' \
       --eval '(arrowgrams/build::arrowgrams-to-json "$1")' \
       --quit
