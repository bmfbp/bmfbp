(in-package :arrowgrams/build)

(defparameter *compiler-net* (arrowgrams/compiler:get-compiler-net))

(defun build (filename)
  (let ((build-net (@defnetwork build

           (:part *compiler-net* compiler (:svg-filename) (:lisp  :metadata :json :error))
           (:code part-namer (:in) (:out))
           (:code json-array-splitter (:in) (:out))
           (:schem build (:svg-filename) (:name :json-file-ref :graph :lisp :error)
            (compiler part-namer json-array-splitter)
            ;; test net - needs to be rewired as components are created
            "
            self.svg-filename -> compiler.svg-filename,part-namer.in

            compiler.metadata -> json-array-splitter.in
            compiler.json -> self.graph

            json-array-splitter.out -> self.json-file-ref
            part-namer.out -> self.name

            compiler.error -> self.error
            "
            )
	   )))

    (@with-dispatch
      (@enable-logging)
      (@inject build-net
               (e/part::get-input-pin build-net :svg-filename)
               filename))))
    
(defun btest ()
  (build (asdf:system-relative-pathname :arrowgrams "build_process/kk/ide.svg")))
