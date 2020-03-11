(in-package :arrowgrams/build)

(defparameter *compiler-net* (arrowgrams/compiler:get-compiler-net))

(defun build (filename)
  (let ((build-net (@defnetwork build

           (:part *compiler-net* compiler (:svg-filename) (:lisp  :metadata :json :error))
           (:code part-namer (:in) (:out))
           (:code json-array-splitter (:in) (:out))
           (:schem compile-single-diagram (:svg-filename) (:name :json-file-ref :json-graph :lisp :error)
            (compiler part-namer json-array-splitter)
            ;; test net - needs to be rewired as components are created
            "
            self.svg-filename -> compiler.svg-filename,part-namer.in

            compiler.metadata -> json-array-splitter.in
            compiler.json -> self.json-graph

            json-array-splitter.out -> self.json-file-ref
            part-namer.out -> self.name

            compiler.error -> self.error
            "
            )

           (:code schematic-or-leaf (:json-ref) (:schematic-json-ref :leaf-json-ref :error))

           (:schem build-recursive (:svg-filename) (:name :graph :leaf-json-ref :error)
            (compile-single-diagram schematic-or-leaf)
            "
            self.svg-filename,schematic-or-leaf.schematic-json-ref -> compile-single-diagram.svg-filename
            
            compile-single-diagram.name -> self.name
            compile-single-diagram.json-graph -> self.graph
            compile-single-diagram.json-file-ref -> schematic-or-leaf.json-ref

            schematic-or-leaf.leaf-json-ref -> self.leaf-json-ref

            compile-single-diagram.error, schematic-or-leaf.error -> self.error 
            ")

           (:code collector (:graph :name :leaf-json-ref :done) (:json-collection :error))
           
           (:schem build (:done :svg-filename) (:json-collection :error)
            (build-recursive collector)
            "
            self.svg-filename -> build-recursive.svg-filename
            self.done -> collector.done

            build-recursive.graph -> collector.graph
            build-recursive.name -> collector.name
            build-recursive.leaf-json-ref -> collector.leaf-json-ref

            collector.json-collection -> self.json-collection

            build-recursive.error,collector.error -> self.error

            ")

	   )))

    (@with-dispatch
      (@enable-logging)
      (let ((pin (e/part::get-input-pin build-net :svg-filename)))
        (@inject build-net pin filename))
      (let ((pin (e/part::get-input-pin build-net :done)))
        (@inject build-net pin T)))))
    
(defun btest ()
  (build (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/ide.svg")))

(defun cl-user::btest ()
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (arrowgrams/build::run-rephrase-parser (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa-dsl.lisp")
                                 (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa.rp"))
  (ql:quickload :arrowgrams/build) ;; reload generated file esa-dsl.lisp
  (arrowgrams/build::run-esa-parser
   (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa.dsl")
   (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/esa.lisp"))
  (ql:quickload :arrowgrams/build) ;; reload generated file esa.lisp
  (arrowgrams/build::btest))