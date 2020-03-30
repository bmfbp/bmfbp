(in-package :arrowgrams/build)

(defparameter *compiler-net* (arrowgrams/compiler:get-compiler-net))

(defun build (filename output-filename alist-filename)
  (let ((build-net (@defnetwork build-load-and-run

           (:code probe (:in) (:out))
           (:code probe2 (:in) (:out))
           (:code probe3 (:in) (:out))

           (:part *compiler-net* compiler (:svg-filename) (:lisp  :metadata :json :error))
           (:code part-namer (:in) (:out))
           (:code json-array-splitter (:array :json) (:items :graph :error))
           (:schem compile-single-diagram (:svg-filename) (:name :json-file-ref :graph :error)
            (compiler part-namer json-array-splitter)
            ;; test net - needs to be rewired as components are created
            "
            self.svg-filename -> compiler.svg-filename,part-namer.in

            compiler.metadata -> json-array-splitter.array
            compiler.json -> json-array-splitter.json

            json-array-splitter.items -> self.json-file-ref
            json-array-splitter.graph -> self.graph

            part-namer.out -> self.name

            compiler.error,json-array-splitter.error -> self.error
            "
            )

           (:code get-manifest-file (:in) (:out :error))
           (:code children-before-graph (:child :graph :graph-name) (:name :graph :descriptor :error))
           (:code schematic-or-leaf (:manifest-as-json-string) (:schematic-filename :child-descriptor :error))

           (:schem build-recursive (:svg-filename) (:name :graph :descriptor :error)
            (compile-single-diagram schematic-or-leaf get-manifest-file children-before-graph)

            "
            schematic-or-leaf.schematic-filename,self.svg-filename -> compile-single-diagram.svg-filename

            compile-single-diagram.name -> children-before-graph.graph-name
            compile-single-diagram.json-file-ref -> get-manifest-file.in
            compile-single-diagram.graph -> children-before-graph.graph

            get-manifest-file.out -> schematic-or-leaf.manifest-as-json-string
            
            schematic-or-leaf.child-descriptor -> children-before-graph.child

            children-before-graph.name -> self.name
            children-before-graph.graph -> self.graph
            children-before-graph.descriptor -> self.descriptor

            compile-single-diagram.error, schematic-or-leaf.error,get-manifest-file.error,children-before-graph.error -> self.error 
            ")

           (:code build-collector (:graph :name :descriptor :done) (:final-code :alist :done :error))
           
           (:schem build (:done :svg-filename) (:json-collection :alist :done :error)
            (build-recursive build-collector)
            "
            self.svg-filename -> build-recursive.svg-filename
            self.done -> build-collector.done

            build-collector.done -> self.done

            build-recursive.graph -> build-collector.graph
            build-recursive.name -> build-collector.name
            build-recursive.descriptor -> build-collector.descriptor

            build-collector.final-code -> self.json-collection
            build-collector.alist -> self.alist

            build-recursive.error,build-collector.error -> self.error

            ")

           (:code file-writer (:filename :write) (:error))
           (:code alist-writer (:filename :write) (:error))
           (:schem build-load-and-run (:done :svg-filename :output-filename :alist-filename) (:error)
            (build file-writer alist-writer)
            "
            self.svg-filename -> build.svg-filename
            self.done -> build.done
            self.output-filename -> file-writer.filename
            self.alist-filename -> alist-writer.filename

            build.json-collection -> file-writer.write
            build.alist -> alist-writer.write

            build.error,file-writer.error,alist-writer.error -> self.error
            ")

	   )))

    (@with-dispatch
      (@enable-logging)
      (let ((pin (e/part::get-input-pin build-net :svg-filename)))
        (@inject build-net pin filename)) ; :tag "build-net filename"))
      (let ((pin (e/part::get-input-pin build-net :output-filename)))
        (@inject build-net pin output-filename)) 
      (let ((pin (e/part::get-input-pin build-net :alist-filename)))
        (@inject build-net pin alist-filename)) 
      (let ((pin (e/part::get-input-pin build-net :done)))
        (@inject build-net pin T )))) ;:tag "build-net done")))))
  "build.lisp done")
    
#+nil(defun btest ()
  (build (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/boot-boot.svg")))

(defun helloworld ()
  (build
   (asdf:system-relative-pathname :arrowgrams "build_process/parts/diagram/helloworld.svg")
   (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/helloworld.graph.json")
   (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/helloworld.graph.lisp")
   ))

(defun cl-user::from-esa ()
  ;; compilation steps after changing esa.dsl
  (ql:quickload :arrowgrams/build)
  (ab::helloworld))

(defun cl-user::from-top ()
  (uiop:run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/rephrase-compiler)
  (ab::make-esa-dsl)
  (ql:quickload :arrowgrams/build)
  (ab::helloworld))
