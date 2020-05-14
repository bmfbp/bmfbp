all:
	buildapp --output cl-arun \
		--load ~/quicklisp/setup.lisp \
		--load "requires" \
		--load "../cl-build/package" \
		--load "esa-methods" \
		--load "esa" \
		--load "make-kind-from-graph" \
		--load "instantiate-kind-recursively" \
		--load "load-and-run" \
		--entry 'arrowgrams/build::main'

#$ buildapp --output lisp-curl --asdf-path ~/src/clbuild/systems/ \
#    --load-system drakma \
#    --eval '(defun main (args) (write-string (drakma:http-request (second args))))' \
#    --entry main
#      --load ~/quicklisp/setup.lisp \
