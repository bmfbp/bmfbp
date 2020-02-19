(in-package :arrowgrams)

(defun atest ()
  (let ((net
         (@defnetwork compile-composite
            (:code compile-one-diagram (:diagram) (:json-graph :error))
            (:code split-diagram (:svg-content) (:diagram :json-metadata :error))
            (:schem compile-composite (:svg) (:json-graph :json-metadata :error)

             :metadata #((dir "build_process/cl-build"
                          file "parts/split_diagram.lisp" 
                          kindName "split-diagram"
                          ref "master"
                          repo "htps://github.com/bmfbp/bmfbp.git")
                         (dir "build_process/cl-build"
                          file "parts/compile_one_diagram.lisp"
                          kindName "compile-one-diagram"
                          ref "master"
                          repo "https://github.com/bmfbp/bmfbp.git"))

              ;; parts
              (compile-one-diagram split-diagram)

              ;; wires
              "
               self.svg -> split-diagram.svg-content

               split-diagram.diagram -> compile-one-diagram.diagrams
               split-diagram.json-metadata -> self.json-metadata

               compile-one-diagram.json-graph -> self.json-graph

               compile-one-diagram.error,split-diagram.error -> self.error
              "))))