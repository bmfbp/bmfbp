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

           (:code build-collector (:graph :name :descriptor :done) (:final-code :done :error))
           
           (:schem build (:done :svg-filename) (:json-collection :done :error)
            (build-recursive build-collector)
            "
            self.svg-filename -> build-recursive.svg-filename
            self.done -> build-collector.done

            build-collector.done -> self.done

            build-recursive.graph -> build-collector.graph
            build-recursive.name -> build-collector.name
            build-recursive.descriptor -> build-collector.descriptor

            build-collector.final-code -> self.json-collection

            build-recursive.error,build-collector.error -> self.error

            ")

           (:code build-graph-in-memory (:json-script :done) (:tree :error))
           (:code runner (:tree) (:error))
           (:schem build-load-and-run (:done :svg-filename) (:error)
            (build build-graph-in-memory runner probe2)
            "
            self.svg-filename -> build.svg-filename
            self.done -> build.done

            build.done -> build-graph-in-memory.done

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
        (@inject build-net pin T ))))) ;:tag "build-net done")))))
    
#+nil(defun btest ()
  (build (asdf:system-relative-pathname :arrowgrams "build_process/lispparts/boot-boot.svg")))

(defun hwtest ()
  (build (asdf:system-relative-pathname :arrowgrams "build_process/parts/diagram/helloworld.svg")))

(defun cl-user::from-esa ()
  ;; compilation steps after changing esa.dsl
  (ql:quickload :arrowgrams/build)
  (ab::hwtest))

(defun cl-user::from-top ()
  (uiop:run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :arrowgrams/rephrase-compiler)
  (ab::make-esa-dsl)
  (ql:quickload :arrowgrams/build))
