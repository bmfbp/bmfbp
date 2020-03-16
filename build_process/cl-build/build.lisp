(in-package :arrowgrams/build)

(defparameter *compiler-net* (arrowgrams/compiler:get-compiler-net))

(defun build (filename)
  (let ((build-net (@defnetwork build-load-and-run

           (:code probe (:in) (:out))
           (:code probe2 (:in) (:out))

           (:part *compiler-net* compiler (:svg-filename) (:lisp  :metadata :json :error))
           (:code part-namer (:in) (:out))
           (:code json-array-splitter (:array :json) (:items :graph :error))
           (:schem compile-single-diagram (:svg-filename) (:name :json-file-ref :json-graph :lisp :error)
            (compiler part-namer json-array-splitter probe2 probe)
            ;; test net - needs to be rewired as components are created
            "
            self.svg-filename -> compiler.svg-filename,part-namer.in

            compiler.metadata -> json-array-splitter.array
            compiler.json -> json-array-splitter.json

            json-array-splitter.items -> self.json-file-ref
            json-array-splitter.graph -> self.json-graph

            part-namer.out -> self.name

            compiler.error,json-array-splitter.error -> self.error
            "
            )

           (:code schematic-or-leaf (:json-ref) (:schematic-json-ref :leaf-json-ref :error))

           (:schem build-recursive (:svg-filename) (:name :graph :leaf-json-ref :error)
            (compile-single-diagram schematic-or-leaf probe)
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

           (:code build-graph-in-memory (:json-script) (:tree :error))
           (:code runner (:tree) (:error))
           (:schem build-load-and-run (:done :svg-filename) (:error)
            (build build-graph-in-memory runner)
            "
            self.svg-filename -> build.svg-filename
            self.done -> build.done

            build.json-collection -> build-graph-in-memory.json-script
            build-graph-in-memory.tree -> runner.tree

            build.error,build-graph-in-memory.error,runner.error -> self.error
            ")

	   )))

    (@with-dispatch
      (@enable-logging)
      (let ((pin (e/part::get-input-pin build-net :svg-filename)))
        (@inject build-net pin filename))
      (let ((pin (e/part::get-input-pin build-net :done)))
        (@inject build-net pin T)))))
    
(defun btest ()
  (build (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/build-recursive.svg")))
  ;(build (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/compile-single-diagram.svg")))

(defun cl-user::btest ()
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (arrowgrams/build::run-rephrase-parser (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa-dsl.lisp")
                                 (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa.rp"))
  (ql:quickload :arrowgrams/build) ;; reload generated file esa-dsl.lisp
  (arrowgrams/build::run-esa-parser
   (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa3.dsl")
   (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/esa.lisp"))
  (ql:quickload :arrowgrams/build) ;; reload generated file esa.lisp
  (arrowgrams/build::btest))
