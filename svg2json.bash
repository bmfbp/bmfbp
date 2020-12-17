#~/bin/bash
# usage: ./svg2json helloworld
sbcl  --noinform \
      --eval '(uiop:run-program "~/quicklisp/local-projects/arrowgrams/rm.bash")' \
      --eval '(ql:register-local-projects)' \
      --eval '(ql:quickload :arrowgrams/build :silent nil)' \
      --eval "(arrowgrams/build::arrowgrams-to-json \"$1\")" \
      --quit
