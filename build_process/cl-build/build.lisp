(in-package :arrowgrams/build)

(defparameter *compiler-net* (arrowgrams/compiler:get-compiler-net))

(defun build (filename)
  (let ((build-net (@defnetwork build-load-and-run

           (:code probe (:in) (:out))
           (:code probe2 (:in) (:out))
           (:code probe3 (:in) (:out))

           (:part *compiler-net* compiler (:svg-filename) (:lisp  :metadata :json :error))
           (:code part-namer (:in) (:out))
           (:code json-array-splitter (:array :json) (:items :graph :error))
           (:schem compile-single-diagram (:svg-filename) (:name :json-file-ref :graph :error)
            (compiler part-namer json-array-splitter probe3)
            ;; test net - needs to be rewired as components are created
            "
            self.svg-filename -> probe3.in
  probe3.out -> compiler.svg-filename,part-namer.in

            compiler.metadata -> json-array-splitter.array
            compiler.json -> json-array-splitter.json

            json-array-splitter.items -> self.json-file-ref
            json-array-splitter.graph -> self.graph

            part-namer.out -> self.name

            compiler.error,json-array-splitter.error -> self.error
            "
            )

           (:code schematic-or-leaf (:json-ref) (:schematic-json-ref :leaf-json-ref :error))

           (:schem build-recursive (:svg-filename) (:name :graph :leaf-json-ref :error)
            (compile-single-diagram schematic-or-leaf probe)
            "
            schematic-or-leaf.schematic-json-ref,self.svg-filename -> probe.in
 probe.out -> compile-single-diagram.svg-filename
            
            compile-single-diagram.name -> self.name
            compile-single-diagram.graph -> self.graph
            compile-single-diagram.json-file-ref -> schematic-or-leaf.json-ref

            schematic-or-leaf.leaf-json-ref -> self.leaf-json-ref

            compile-single-diagram.error, schematic-or-leaf.error -> self.error 
            ")

           (:code build-collector (:graph :name :leaf-json-ref :done) (:json-collection :done :error))
           
           (:schem build (:done :svg-filename) (:json-collection :done :error)
            (build-recursive build-collector)
            "
            self.svg-filename -> build-recursive.svg-filename
            self.done -> build-collector.done

            build-collector.done -> self.done

            build-recursive.graph -> build-collector.graph
            build-recursive.name -> build-collector.name
            build-recursive.leaf-json-ref -> build-collector.leaf-json-ref

            build-collector.json-collection -> self.json-collection

            build-recursive.error,build-collector.error -> self.error

            ")

           (:code build-graph-in-memory (:json-script :done) (:tree :error))
           (:code runner (:tree) (:error))
           (:schem build-load-and-run (:done :svg-filename) (:error)
            (build build-graph-in-memory runner probe2)
            "
            self.svg-filename -> build.svg-filename
            self.done -> build.done

            build.done -> probe2.in
  probe2.out -> build-graph-in-memory.done

            build.json-collection -> build-graph-in-memory.json-script
            build-graph-in-memory.tree -> runner.tree

            build.error,build-graph-in-memory.error,runner.error -> self.error
            ")

	   )))

    (@with-dispatch
      (@enable-logging)
      (let ((pin (e/part::get-input-pin build-net :svg-filename)))
        (@inject build-net pin filename)) ; :tag "build-net filename"))
      (let ((pin (e/part::get-input-pin build-net :done)))
        (@inject build-net pin T :tag "build-net done")))))
    
(defun btest ()
  ;(build (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/build-recursive.svg")))
  (build (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/compile-single-diagram.svg")))

(defun cl-user::btest ()
  ;(asdf::run-program "rm -rf ~/.cache/common-lisp")
  (asdf::run-program "rm -rf /Users/tarvydas/.cache/common-lisp/sbcl-1.5.9-macosx-x64/Users/tarvydas/quicklisp/local-projects/bmfbp")
  (arrowgrams/build::run-rephrase-parser (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa-dsl.lisp")
                                 (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa.rp"))
  (ql:quickload :arrowgrams/build) ;; reload generated file esa-dsl.lisp
  (arrowgrams/build::run-esa-parser
   (asdf:system-relative-pathname :arrowgrams "build_process/esa/esa3.dsl")
   (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/esa.lisp"))
  (ql:quickload :arrowgrams/build) ;; reload generated file esa.lisp
  (arrowgrams/build::btest))
