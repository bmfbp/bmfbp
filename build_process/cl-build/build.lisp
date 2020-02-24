(in-package :arrowgrams/build)

(defparameter *compiler-net* (arrowgrams/compiler:get-compiler-net))

(defun build (filename)
  (let ((build-net (@defnetwork build

           (:part *compiler-net* compiler (:svg-filename) (:lisp  :metadata :json :error))
           (:code part-namer (:in) (:out))
           (:code json-array-splitter (:in) (:out))
           (:schem compile-single-diagram (:svg-filename :finished-pipeline) (:name :json-file-ref :json-graph :lisp :error)
            (compiler part-namer json-array-splitter)
            ;; test net - needs to be rewired as components are created
            "
            self.svg-filename -> compiler.svg-filename,part-namer.in
            self.finished-pipeline -> compile-single-diagram.finished-pipeline

            compiler.metadata -> json-array-splitter.in
            compiler.json -> self.json-graph

            json-array-splitter.out -> self.json-file-ref
            part-namer.out -> self.name

            compiler.error -> self.error
            "
            )

           (:code schematic-fetcher (:json-ref) (:filename :error))
           (:code schematic-or-leaf (:json-ref) (:schematic-json-ref :leaf-json-ref :error))

           (:schem build (:svg-filename) (:name :graph :leaf-json-ref :error)
            (compile-single-diagram schematic-fetcher schematic-or-leaf)
            "
            self.svg-filename,schematic-or-leaf.schematic-json-ref -> compile-single-diagram.svg-filename
            
            compile-single-diagram.name -> self.name
            compile-single-diagram.json-graph -> self.graph,compile-single-diagram.finished-pipeline
            compile-single-diagram.json-file-ref -> schematic-or-leaf.json-ref

            schematic-or-leaf.leaf-json-ref -> self.leaf-json-ref

            schematic-fetcher.filename -> compile-single-diagram.svg-filename

            compile-single-diagram.error, schematic-fetcher.error, schematic-or-leaf.error -> self.error 
            ")

	   )))

    (@with-dispatch
      (@enable-logging)
      (@inject build-net
               (e/part::get-input-pin build-net :svg-filename)
               filename))))
    
(defun btest ()
  (build (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/build-process.svg")))

(defun cl-user::btest ()
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/build)
  (arrowgrams/build::btest))