(in-package :arrowgrams/build)

(defparameter *compiler-net* (arrowgrams/compiler:get-compiler-net))

(defun build (filename output-filename alist-filename)
  (let ((build-net #+nil (@defnetwork build-json

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
           (:schem build-json (:done :svg-filename :output-filename :alist-filename) (:error)
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

	   )
(PROGN
 (@INITIALIZE)
 (LET ((PROBE
        (@NEW-CODE :KIND 'PROBE :NAME "PROBE" :INPUT-HANDLER
                   #'CL-EVENT-PASSING-PART:REACT :INPUT-PINS '(:IN)
                   :OUTPUT-PINS '(:OUT) :FIRST-TIME-HANDLER
                   #'CL-EVENT-PASSING-PART:FIRST-TIME)))
   (LET ((PROBE2
          (@NEW-CODE :KIND 'PROBE2 :NAME "PROBE2" :INPUT-HANDLER
                     #'CL-EVENT-PASSING-PART:REACT :INPUT-PINS '(:IN)
                     :OUTPUT-PINS '(:OUT) :FIRST-TIME-HANDLER
                     #'CL-EVENT-PASSING-PART:FIRST-TIME)))
     (LET ((PROBE3
            (@NEW-CODE :KIND 'PROBE3 :NAME "PROBE3" :INPUT-HANDLER
                       #'CL-EVENT-PASSING-PART:REACT :INPUT-PINS '(:IN)
                       :OUTPUT-PINS '(:OUT) :FIRST-TIME-HANDLER
                       #'CL-EVENT-PASSING-PART:FIRST-TIME)))
       (LET ((COMPILER
              (@REUSE-PART *COMPILER-NET* :NAME 'COMPILER :INPUT-PINS
                           '(:SVG-FILENAME) :OUTPUT-PINS
                           '(:LISP :METADATA :JSON :ERROR))))
         (LET ((PART-NAMER
                (@NEW-CODE :KIND 'PART-NAMER :NAME "PART-NAMER" :INPUT-HANDLER
                           #'CL-EVENT-PASSING-PART:REACT :INPUT-PINS '(:IN)
                           :OUTPUT-PINS '(:OUT) :FIRST-TIME-HANDLER
                           #'CL-EVENT-PASSING-PART:FIRST-TIME)))
           (LET ((JSON-ARRAY-SPLITTER
                  (@NEW-CODE :KIND 'JSON-ARRAY-SPLITTER :NAME
                             "JSON-ARRAY-SPLITTER" :INPUT-HANDLER
                             #'CL-EVENT-PASSING-PART:REACT :INPUT-PINS
                             '(:ARRAY :JSON) :OUTPUT-PINS
                             '(:ITEMS :GRAPH :ERROR) :FIRST-TIME-HANDLER
                             #'CL-EVENT-PASSING-PART:FIRST-TIME)))
             (LET ((COMPILE-SINGLE-DIAGRAM
                    (@NEW-SCHEMATIC :NAME "COMPILE-SINGLE-DIAGRAM" :INPUT-PINS
                                    '(:SVG-FILENAME) :OUTPUT-PINS
                                    '(:NAME :JSON-FILE-REF :GRAPH :ERROR)
                                    :FIRST-TIME-HANDLER NIL)))
               (@ADD-PART-TO-SCHEMATIC COMPILE-SINGLE-DIAGRAM COMPILER)
               (@ADD-PART-TO-SCHEMATIC COMPILE-SINGLE-DIAGRAM PART-NAMER)
               (@ADD-PART-TO-SCHEMATIC COMPILE-SINGLE-DIAGRAM
                                       JSON-ARRAY-SPLITTER)
               (LET ((WIRE-585
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  COMPILER
                                                                  :PIN-NAME
                                                                  :SVG-FILENAME
                                                                  :DIRECTION
                                                                  :INPUT))
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  PART-NAMER
                                                                  :PIN-NAME :IN
                                                                  :DIRECTION
                                                                  :INPUT)))))
                     (WIRE-586
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  JSON-ARRAY-SPLITTER
                                                                  :PIN-NAME
                                                                  :ARRAY
                                                                  :DIRECTION
                                                                  :INPUT)))))
                     (WIRE-587
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  JSON-ARRAY-SPLITTER
                                                                  :PIN-NAME
                                                                  :JSON
                                                                  :DIRECTION
                                                                  :INPUT)))))
                     (WIRE-588
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  COMPILE-SINGLE-DIAGRAM
                                                                  :PIN-NAME
                                                                  :JSON-FILE-REF
                                                                  :DIRECTION
                                                                  :OUTPUT)))))
                     (WIRE-589
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  COMPILE-SINGLE-DIAGRAM
                                                                  :PIN-NAME
                                                                  :GRAPH
                                                                  :DIRECTION
                                                                  :OUTPUT)))))
                     (WIRE-590
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  COMPILE-SINGLE-DIAGRAM
                                                                  :PIN-NAME
                                                                  :NAME
                                                                  :DIRECTION
                                                                  :OUTPUT)))))
                     (WIRE-591
                      (CL-EVENT-PASSING::MAKE-WIRE
                       (LIST
                        (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                 (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                  :PIN-PARENT
                                                                  COMPILE-SINGLE-DIAGRAM
                                                                  :PIN-NAME
                                                                  :ERROR
                                                                  :DIRECTION
                                                                  :OUTPUT))))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                  COMPILE-SINGLE-DIAGRAM WIRE-585
                  (LIST
                   (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                         :PIN-PARENT
                                                         COMPILE-SINGLE-DIAGRAM
                                                         :PIN-NAME
                                                         :SVG-FILENAME
                                                         :DIRECTION :INPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                  COMPILE-SINGLE-DIAGRAM WIRE-586
                  (LIST
                   (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                         :PIN-PARENT COMPILER
                                                         :PIN-NAME :METADATA
                                                         :DIRECTION :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                  COMPILE-SINGLE-DIAGRAM WIRE-587
                  (LIST
                   (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                         :PIN-PARENT COMPILER
                                                         :PIN-NAME :JSON
                                                         :DIRECTION :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                  COMPILE-SINGLE-DIAGRAM WIRE-588
                  (LIST
                   (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                         :PIN-PARENT
                                                         JSON-ARRAY-SPLITTER
                                                         :PIN-NAME :ITEMS
                                                         :DIRECTION :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                  COMPILE-SINGLE-DIAGRAM WIRE-589
                  (LIST
                   (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                         :PIN-PARENT
                                                         JSON-ARRAY-SPLITTER
                                                         :PIN-NAME :GRAPH
                                                         :DIRECTION :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                  COMPILE-SINGLE-DIAGRAM WIRE-590
                  (LIST
                   (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                         :PIN-PARENT PART-NAMER
                                                         :PIN-NAME :OUT
                                                         :DIRECTION :OUTPUT))))
                 (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                  COMPILE-SINGLE-DIAGRAM WIRE-591
                  (LIST
                   (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                         :PIN-PARENT COMPILER
                                                         :PIN-NAME :ERROR
                                                         :DIRECTION :OUTPUT))
                   (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                         :PIN-PARENT
                                                         JSON-ARRAY-SPLITTER
                                                         :PIN-NAME :ERROR
                                                         :DIRECTION
                                                         :OUTPUT)))))
               (LET ((GET-MANIFEST-FILE
                      (@NEW-CODE :KIND 'GET-MANIFEST-FILE :NAME
                                 "GET-MANIFEST-FILE" :INPUT-HANDLER
                                 #'CL-EVENT-PASSING-PART:REACT :INPUT-PINS
                                 '(:IN) :OUTPUT-PINS '(:OUT :ERROR)
                                 :FIRST-TIME-HANDLER
                                 #'CL-EVENT-PASSING-PART:FIRST-TIME)))
                 (LET ((CHILDREN-BEFORE-GRAPH
                        (@NEW-CODE :KIND 'CHILDREN-BEFORE-GRAPH :NAME
                                   "CHILDREN-BEFORE-GRAPH" :INPUT-HANDLER
                                   #'CL-EVENT-PASSING-PART:REACT :INPUT-PINS
                                   '(:CHILD :GRAPH :GRAPH-NAME) :OUTPUT-PINS
                                   '(:NAME :GRAPH :DESCRIPTOR :ERROR)
                                   :FIRST-TIME-HANDLER
                                   #'CL-EVENT-PASSING-PART:FIRST-TIME)))
                   (LET ((SCHEMATIC-OR-LEAF
                          (@NEW-CODE :KIND 'SCHEMATIC-OR-LEAF :NAME
                                     "SCHEMATIC-OR-LEAF" :INPUT-HANDLER
                                     #'CL-EVENT-PASSING-PART:REACT :INPUT-PINS
                                     '(:MANIFEST-AS-JSON-STRING) :OUTPUT-PINS
                                     '(:SCHEMATIC-FILENAME :CHILD-DESCRIPTOR
                                       :ERROR)
                                     :FIRST-TIME-HANDLER
                                     #'CL-EVENT-PASSING-PART:FIRST-TIME)))
                     (LET ((BUILD-RECURSIVE
                            (@NEW-SCHEMATIC :NAME "BUILD-RECURSIVE" :INPUT-PINS
                                            '(:SVG-FILENAME) :OUTPUT-PINS
                                            '(:NAME :GRAPH :DESCRIPTOR :ERROR)
                                            :FIRST-TIME-HANDLER NIL)))
                       (@ADD-PART-TO-SCHEMATIC BUILD-RECURSIVE
                                               COMPILE-SINGLE-DIAGRAM)
                       (@ADD-PART-TO-SCHEMATIC BUILD-RECURSIVE
                                               SCHEMATIC-OR-LEAF)
                       (@ADD-PART-TO-SCHEMATIC BUILD-RECURSIVE
                                               GET-MANIFEST-FILE)
                       (@ADD-PART-TO-SCHEMATIC BUILD-RECURSIVE
                                               CHILDREN-BEFORE-GRAPH)
                       (LET ((WIRE-592
                              (CL-EVENT-PASSING::MAKE-WIRE
                               (LIST
                                (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                         (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                          :PIN-PARENT
                                                                          COMPILE-SINGLE-DIAGRAM
                                                                          :PIN-NAME
                                                                          :SVG-FILENAME
                                                                          :DIRECTION
                                                                          :INPUT)))))
                             (WIRE-593
                              (CL-EVENT-PASSING::MAKE-WIRE
                               (LIST
                                (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                         (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                          :PIN-PARENT
                                                                          CHILDREN-BEFORE-GRAPH
                                                                          :PIN-NAME
                                                                          :GRAPH-NAME
                                                                          :DIRECTION
                                                                          :INPUT)))))
                             (WIRE-594
                              (CL-EVENT-PASSING::MAKE-WIRE
                               (LIST
                                (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                         (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                          :PIN-PARENT
                                                                          GET-MANIFEST-FILE
                                                                          :PIN-NAME
                                                                          :IN
                                                                          :DIRECTION
                                                                          :INPUT)))))
                             (WIRE-595
                              (CL-EVENT-PASSING::MAKE-WIRE
                               (LIST
                                (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                         (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                          :PIN-PARENT
                                                                          CHILDREN-BEFORE-GRAPH
                                                                          :PIN-NAME
                                                                          :GRAPH
                                                                          :DIRECTION
                                                                          :INPUT)))))
                             (WIRE-596
                              (CL-EVENT-PASSING::MAKE-WIRE
                               (LIST
                                (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                         (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                          :PIN-PARENT
                                                                          SCHEMATIC-OR-LEAF
                                                                          :PIN-NAME
                                                                          :MANIFEST-AS-JSON-STRING
                                                                          :DIRECTION
                                                                          :INPUT)))))
                             (WIRE-597
                              (CL-EVENT-PASSING::MAKE-WIRE
                               (LIST
                                (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                         (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                          :PIN-PARENT
                                                                          CHILDREN-BEFORE-GRAPH
                                                                          :PIN-NAME
                                                                          :CHILD
                                                                          :DIRECTION
                                                                          :INPUT)))))
                             (WIRE-598
                              (CL-EVENT-PASSING::MAKE-WIRE
                               (LIST
                                (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                         (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                          :PIN-PARENT
                                                                          BUILD-RECURSIVE
                                                                          :PIN-NAME
                                                                          :NAME
                                                                          :DIRECTION
                                                                          :OUTPUT)))))
                             (WIRE-599
                              (CL-EVENT-PASSING::MAKE-WIRE
                               (LIST
                                (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                         (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                          :PIN-PARENT
                                                                          BUILD-RECURSIVE
                                                                          :PIN-NAME
                                                                          :GRAPH
                                                                          :DIRECTION
                                                                          :OUTPUT)))))
                             (WIRE-600
                              (CL-EVENT-PASSING::MAKE-WIRE
                               (LIST
                                (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                         (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                          :PIN-PARENT
                                                                          BUILD-RECURSIVE
                                                                          :PIN-NAME
                                                                          :DESCRIPTOR
                                                                          :DIRECTION
                                                                          :OUTPUT)))))
                             (WIRE-601
                              (CL-EVENT-PASSING::MAKE-WIRE
                               (LIST
                                (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER :PIN
                                                                         (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                          :PIN-PARENT
                                                                          BUILD-RECURSIVE
                                                                          :PIN-NAME
                                                                          :ERROR
                                                                          :DIRECTION
                                                                          :OUTPUT))))))
                         (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                          BUILD-RECURSIVE WIRE-592
                          (LIST
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 SCHEMATIC-OR-LEAF
                                                                 :PIN-NAME
                                                                 :SCHEMATIC-FILENAME
                                                                 :DIRECTION
                                                                 :OUTPUT))
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 BUILD-RECURSIVE
                                                                 :PIN-NAME
                                                                 :SVG-FILENAME
                                                                 :DIRECTION
                                                                 :INPUT))))
                         (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                          BUILD-RECURSIVE WIRE-593
                          (LIST
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 COMPILE-SINGLE-DIAGRAM
                                                                 :PIN-NAME
                                                                 :NAME
                                                                 :DIRECTION
                                                                 :OUTPUT))))
                         (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                          BUILD-RECURSIVE WIRE-594
                          (LIST
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 COMPILE-SINGLE-DIAGRAM
                                                                 :PIN-NAME
                                                                 :JSON-FILE-REF
                                                                 :DIRECTION
                                                                 :OUTPUT))))
                         (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                          BUILD-RECURSIVE WIRE-595
                          (LIST
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 COMPILE-SINGLE-DIAGRAM
                                                                 :PIN-NAME
                                                                 :GRAPH
                                                                 :DIRECTION
                                                                 :OUTPUT))))
                         (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                          BUILD-RECURSIVE WIRE-596
                          (LIST
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 GET-MANIFEST-FILE
                                                                 :PIN-NAME :OUT
                                                                 :DIRECTION
                                                                 :OUTPUT))))
                         (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                          BUILD-RECURSIVE WIRE-597
                          (LIST
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 SCHEMATIC-OR-LEAF
                                                                 :PIN-NAME
                                                                 :CHILD-DESCRIPTOR
                                                                 :DIRECTION
                                                                 :OUTPUT))))
                         (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                          BUILD-RECURSIVE WIRE-598
                          (LIST
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 CHILDREN-BEFORE-GRAPH
                                                                 :PIN-NAME
                                                                 :NAME
                                                                 :DIRECTION
                                                                 :OUTPUT))))
                         (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                          BUILD-RECURSIVE WIRE-599
                          (LIST
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 CHILDREN-BEFORE-GRAPH
                                                                 :PIN-NAME
                                                                 :GRAPH
                                                                 :DIRECTION
                                                                 :OUTPUT))))
                         (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                          BUILD-RECURSIVE WIRE-600
                          (LIST
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 CHILDREN-BEFORE-GRAPH
                                                                 :PIN-NAME
                                                                 :DESCRIPTOR
                                                                 :DIRECTION
                                                                 :OUTPUT))))
                         (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                          BUILD-RECURSIVE WIRE-601
                          (LIST
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 COMPILE-SINGLE-DIAGRAM
                                                                 :PIN-NAME
                                                                 :ERROR
                                                                 :DIRECTION
                                                                 :OUTPUT))
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 SCHEMATIC-OR-LEAF
                                                                 :PIN-NAME
                                                                 :ERROR
                                                                 :DIRECTION
                                                                 :OUTPUT))
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 GET-MANIFEST-FILE
                                                                 :PIN-NAME
                                                                 :ERROR
                                                                 :DIRECTION
                                                                 :OUTPUT))
                           (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                 :PIN-PARENT
                                                                 CHILDREN-BEFORE-GRAPH
                                                                 :PIN-NAME
                                                                 :ERROR
                                                                 :DIRECTION
                                                                 :OUTPUT)))))
                       (LET ((BUILD-COLLECTOR
                              (@NEW-CODE :KIND 'BUILD-COLLECTOR :NAME
                                         "BUILD-COLLECTOR" :INPUT-HANDLER
                                         #'CL-EVENT-PASSING-PART:REACT
                                         :INPUT-PINS
                                         '(:GRAPH :NAME :DESCRIPTOR :DONE)
                                         :OUTPUT-PINS
                                         '(:FINAL-CODE :ALIST :DONE :ERROR)
                                         :FIRST-TIME-HANDLER
                                         #'CL-EVENT-PASSING-PART:FIRST-TIME)))
                         (LET ((BUILD
                                (@NEW-SCHEMATIC :NAME "BUILD" :INPUT-PINS
                                                '(:DONE :SVG-FILENAME)
                                                :OUTPUT-PINS
                                                '(:JSON-COLLECTION :ALIST :DONE
                                                  :ERROR)
                                                :FIRST-TIME-HANDLER NIL)))
                           (@ADD-PART-TO-SCHEMATIC BUILD BUILD-RECURSIVE)
                           (@ADD-PART-TO-SCHEMATIC BUILD BUILD-COLLECTOR)
                           (LET ((WIRE-602
                                  (CL-EVENT-PASSING::MAKE-WIRE
                                   (LIST
                                    (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                     :PIN
                                     (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                      :PIN-PARENT BUILD-RECURSIVE :PIN-NAME
                                      :SVG-FILENAME :DIRECTION :INPUT)))))
                                 (WIRE-603
                                  (CL-EVENT-PASSING::MAKE-WIRE
                                   (LIST
                                    (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                     :PIN
                                     (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                      :PIN-PARENT BUILD-COLLECTOR :PIN-NAME
                                      :DONE :DIRECTION :INPUT)))))
                                 (WIRE-604
                                  (CL-EVENT-PASSING::MAKE-WIRE
                                   (LIST
                                    (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                     :PIN
                                     (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                      :PIN-PARENT BUILD :PIN-NAME :DONE
                                      :DIRECTION :OUTPUT)))))
                                 (WIRE-605
                                  (CL-EVENT-PASSING::MAKE-WIRE
                                   (LIST
                                    (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                     :PIN
                                     (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                      :PIN-PARENT BUILD-COLLECTOR :PIN-NAME
                                      :GRAPH :DIRECTION :INPUT)))))
                                 (WIRE-606
                                  (CL-EVENT-PASSING::MAKE-WIRE
                                   (LIST
                                    (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                     :PIN
                                     (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                      :PIN-PARENT BUILD-COLLECTOR :PIN-NAME
                                      :NAME :DIRECTION :INPUT)))))
                                 (WIRE-607
                                  (CL-EVENT-PASSING::MAKE-WIRE
                                   (LIST
                                    (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                     :PIN
                                     (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                      :PIN-PARENT BUILD-COLLECTOR :PIN-NAME
                                      :DESCRIPTOR :DIRECTION :INPUT)))))
                                 (WIRE-608
                                  (CL-EVENT-PASSING::MAKE-WIRE
                                   (LIST
                                    (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                     :PIN
                                     (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                      :PIN-PARENT BUILD :PIN-NAME
                                      :JSON-COLLECTION :DIRECTION :OUTPUT)))))
                                 (WIRE-609
                                  (CL-EVENT-PASSING::MAKE-WIRE
                                   (LIST
                                    (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                     :PIN
                                     (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                      :PIN-PARENT BUILD :PIN-NAME :ALIST
                                      :DIRECTION :OUTPUT)))))
                                 (WIRE-610
                                  (CL-EVENT-PASSING::MAKE-WIRE
                                   (LIST
                                    (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                     :PIN
                                     (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                      :PIN-PARENT BUILD :PIN-NAME :ERROR
                                      :DIRECTION :OUTPUT))))))
                             (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE BUILD
                                                                      WIRE-602
                                                                      (LIST
                                                                       (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                                        :PIN
                                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                         :PIN-PARENT
                                                                         BUILD
                                                                         :PIN-NAME
                                                                         :SVG-FILENAME
                                                                         :DIRECTION
                                                                         :INPUT))))
                             (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE BUILD
                                                                      WIRE-603
                                                                      (LIST
                                                                       (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                                        :PIN
                                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                         :PIN-PARENT
                                                                         BUILD
                                                                         :PIN-NAME
                                                                         :DONE
                                                                         :DIRECTION
                                                                         :INPUT))))
                             (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE BUILD
                                                                      WIRE-604
                                                                      (LIST
                                                                       (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                                        :PIN
                                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                         :PIN-PARENT
                                                                         BUILD-COLLECTOR
                                                                         :PIN-NAME
                                                                         :DONE
                                                                         :DIRECTION
                                                                         :OUTPUT))))
                             (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE BUILD
                                                                      WIRE-605
                                                                      (LIST
                                                                       (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                                        :PIN
                                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                         :PIN-PARENT
                                                                         BUILD-RECURSIVE
                                                                         :PIN-NAME
                                                                         :GRAPH
                                                                         :DIRECTION
                                                                         :OUTPUT))))
                             (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE BUILD
                                                                      WIRE-606
                                                                      (LIST
                                                                       (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                                        :PIN
                                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                         :PIN-PARENT
                                                                         BUILD-RECURSIVE
                                                                         :PIN-NAME
                                                                         :NAME
                                                                         :DIRECTION
                                                                         :OUTPUT))))
                             (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE BUILD
                                                                      WIRE-607
                                                                      (LIST
                                                                       (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                                        :PIN
                                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                         :PIN-PARENT
                                                                         BUILD-RECURSIVE
                                                                         :PIN-NAME
                                                                         :DESCRIPTOR
                                                                         :DIRECTION
                                                                         :OUTPUT))))
                             (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE BUILD
                                                                      WIRE-608
                                                                      (LIST
                                                                       (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                                        :PIN
                                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                         :PIN-PARENT
                                                                         BUILD-COLLECTOR
                                                                         :PIN-NAME
                                                                         :FINAL-CODE
                                                                         :DIRECTION
                                                                         :OUTPUT))))
                             (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE BUILD
                                                                      WIRE-609
                                                                      (LIST
                                                                       (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                                        :PIN
                                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                         :PIN-PARENT
                                                                         BUILD-COLLECTOR
                                                                         :PIN-NAME
                                                                         :ALIST
                                                                         :DIRECTION
                                                                         :OUTPUT))))
                             (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE BUILD
                                                                      WIRE-610
                                                                      (LIST
                                                                       (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                                        :PIN
                                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                         :PIN-PARENT
                                                                         BUILD-RECURSIVE
                                                                         :PIN-NAME
                                                                         :ERROR
                                                                         :DIRECTION
                                                                         :OUTPUT))
                                                                       (CL-EVENT-PASSING-SOURCE::NEW-SOURCE
                                                                        :PIN
                                                                        (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                         :PIN-PARENT
                                                                         BUILD-COLLECTOR
                                                                         :PIN-NAME
                                                                         :ERROR
                                                                         :DIRECTION
                                                                         :OUTPUT)))))
                           (LET ((FILE-WRITER
                                  (@NEW-CODE :KIND 'FILE-WRITER :NAME
                                             "FILE-WRITER" :INPUT-HANDLER
                                             #'CL-EVENT-PASSING-PART:REACT
                                             :INPUT-PINS '(:FILENAME :WRITE)
                                             :OUTPUT-PINS '(:ERROR)
                                             :FIRST-TIME-HANDLER
                                             #'CL-EVENT-PASSING-PART:FIRST-TIME)))
                             (LET ((ALIST-WRITER
                                    (@NEW-CODE :KIND 'ALIST-WRITER :NAME
                                               "ALIST-WRITER" :INPUT-HANDLER
                                               #'CL-EVENT-PASSING-PART:REACT
                                               :INPUT-PINS '(:FILENAME :WRITE)
                                               :OUTPUT-PINS '(:ERROR)
                                               :FIRST-TIME-HANDLER
                                               #'CL-EVENT-PASSING-PART:FIRST-TIME)))
                               (LET ((BUILD-JSON
                                      (@NEW-SCHEMATIC :NAME
                                                      "BUILD-JSON"
                                                      :INPUT-PINS
                                                      '(:DONE :SVG-FILENAME
                                                        :OUTPUT-FILENAME
                                                        :ALIST-FILENAME)
                                                      :OUTPUT-PINS '(:ERROR)
                                                      :FIRST-TIME-HANDLER NIL)))
                                 (@ADD-PART-TO-SCHEMATIC BUILD-JSON
                                                         BUILD)
                                 (@ADD-PART-TO-SCHEMATIC BUILD-JSON
                                                         FILE-WRITER)
                                 (@ADD-PART-TO-SCHEMATIC BUILD-JSON
                                                         ALIST-WRITER)
                                 (LET ((WIRE-611
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT BUILD :PIN-NAME
                                            :SVG-FILENAME :DIRECTION
                                            :INPUT)))))
                                       (WIRE-612
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT BUILD :PIN-NAME :DONE
                                            :DIRECTION :INPUT)))))
                                       (WIRE-613
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT FILE-WRITER :PIN-NAME
                                            :FILENAME :DIRECTION :INPUT)))))
                                       (WIRE-614
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT ALIST-WRITER :PIN-NAME
                                            :FILENAME :DIRECTION :INPUT)))))
                                       (WIRE-615
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT FILE-WRITER :PIN-NAME
                                            :WRITE :DIRECTION :INPUT)))))
                                       (WIRE-616
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT ALIST-WRITER :PIN-NAME
                                            :WRITE :DIRECTION :INPUT)))))
                                       (WIRE-617
                                        (CL-EVENT-PASSING::MAKE-WIRE
                                         (LIST
                                          (CL-EVENT-PASSING-RECEIVER::NEW-RECEIVER
                                           :PIN
                                           (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                            :PIN-PARENT BUILD-JSON
                                            :PIN-NAME :ERROR :DIRECTION
                                            :OUTPUT))))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    BUILD-JSON WIRE-611
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           BUILD-JSON
                                                                           :PIN-NAME
                                                                           :SVG-FILENAME
                                                                           :DIRECTION
                                                                           :INPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    BUILD-JSON WIRE-612
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           BUILD-JSON
                                                                           :PIN-NAME
                                                                           :DONE
                                                                           :DIRECTION
                                                                           :INPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    BUILD-JSON WIRE-613
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           BUILD-JSON
                                                                           :PIN-NAME
                                                                           :OUTPUT-FILENAME
                                                                           :DIRECTION
                                                                           :INPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    BUILD-JSON WIRE-614
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           BUILD-JSON
                                                                           :PIN-NAME
                                                                           :ALIST-FILENAME
                                                                           :DIRECTION
                                                                           :INPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    BUILD-JSON WIRE-615
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           BUILD
                                                                           :PIN-NAME
                                                                           :JSON-COLLECTION
                                                                           :DIRECTION
                                                                           :OUTPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    BUILD-JSON WIRE-616
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           BUILD
                                                                           :PIN-NAME
                                                                           :ALIST
                                                                           :DIRECTION
                                                                           :OUTPUT))))
                                   (CL-EVENT-PASSING::MAKE-SOURCES-FOR-WIRE
                                    BUILD-JSON WIRE-617
                                    (LIST
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           BUILD
                                                                           :PIN-NAME
                                                                           :ERROR
                                                                           :DIRECTION
                                                                           :OUTPUT))
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           FILE-WRITER
                                                                           :PIN-NAME
                                                                           :ERROR
                                                                           :DIRECTION
                                                                           :OUTPUT))
                                     (CL-EVENT-PASSING-SOURCE::NEW-SOURCE :PIN
                                                                          (CL-EVENT-PASSING-PIN::EXISTING-PIN
                                                                           :PIN-PARENT
                                                                           ALIST-WRITER
                                                                           :PIN-NAME
                                                                           :ERROR
                                                                           :DIRECTION
                                                                           :OUTPUT)))))
                                 (LET ()
                                   (@TOP-LEVEL-SCHEMATIC BUILD-JSON)
                                   (CL-EVENT-PASSING-USER-UTIL::CHECK-TOP-LEVEL-SCHEMATIC-SANITY
                                    BUILD-JSON)
                                   BUILD-JSON))))))))))))))))))
))

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

(defun arrowgrams-to-json ()
  (handler-case
      (let ((args (my-command-line)))
	(let ((infile (if (> (length args) 1)
			  (second args)
 			  (asdf:system-relative-pathname :arrowgrams "build_process/parts/diagram/helloworld.svg"))))
	  (format *standard-output* "~&compiling ~s~%" infile)
	  (build
	   infile
	   (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/helloworld.graph.json")
	   (asdf:system-relative-pathname :arrowgrams "build_process/cl-build/helloworld.graph.lisp")
	   )))
    (end-of-file (c)
      (format *error-output* "FATAL 'end of file error; in main ~a~%" c))
    (simple-error (c)
      (format *error-output* "FATAL error in main ~a~%" c))
    (error (c)
      (format *error-output* "FATAL error in main ~a~%" c))))
