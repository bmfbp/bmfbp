(in-package :arrowgrams/build)

(defparameter *dispatcher* nil)

(defun instantiate-graph (top-kind)
  ;; KIND is built up in build-graph-in-memory
  ;; instantiate all parts in the graph and assign them to named slots in each appropriate level
  (let ((d (make-instance 'dispatcher)))  ;; make one "global" dispatcher
    (setf *dispatcher* d)
    (let ((n (loader top-kind "TOP" nil d))) ;; call to esa --> node
      (set-top-node d n)
      (values d n)))) ;; return dispatcher and top node

(defun initialize-graph (esa-dispatcher)
  (initialize-all esa-dispatcher))

(defun run-graph (esa-dispatcher)
  (start esa-dispatcher))



(defun test-run ()
  (format *standard-output* "~&test-run~%")
  (let ((fake (make-instance 'build-graph-in-memory)))
    (reset fake)
    (let ((top-most-kind (process-code fake *test-descriptors*)))
      (multiple-value-bind (dispatchr top-node)
          (instantiate-graph top-most-kind)
        (initialize-graph dispatchr)
	(let ((diagram-name (asdf:system-relative-pathname :arrowgrams "build_process/lisppparts/boot-boot.svg")))
	  (let ((ev (make-instance 'event)))
	    (setf (part-name ev) "boot-boot")
	    (setf (part-name ev) "svg-filename")
	    (setf (data ev) diagram-name)
	    (enqueue-input top-node ev)))
        (run-graph dispatchr)))))


(defparameter *test-descriptors* 
  '(
    ((:item-kind . "leaf") (:NAME . "compiler") (:IN-PINS "svg-filename") (:OUT-PINS "metadata" "json" "lisp" "error") (:KIND . "compiler")) 
    ((:item-kind . "leaf") (:NAME . "part-namer") (:IN-PINS "filename") (:OUT-PINS "name" "error") (:KIND . "part-namer") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/part-namer.lisp")) 
    ((:item-kind . "leaf") (:NAME . "json-array-splitter") (:IN-PINS "array" "json") (:OUT-PINS "items" "graph" "error") (:KIND . "json-array-splitter") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/json-array-splitter.lisp")) 
    ((:item-kind . "leaf") (:NAME . "children-before-graph") (:IN-PINS "graph-name" "graph" "child") (:OUT-PINS "name" "graph" "descriptor" "error") (:KIND . "children-before-graph") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/children-before-graph.lisp")) 
    ((:item-kind . "leaf") (:NAME . "build-collector") (:IN-PINS "graph" "name" "descriptor" "done") (:OUT-PINS "final-code" "done" "error") (:KIND . "build-collector") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/build-collector.lisp")) 
    ((:item-kind . "leaf") (:NAME . "get-manifest-file") (:IN-PINS "in") (:OUT-PINS "out" "error") (:KIND . "get-manifest-file") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/get-manifest-file.lisp")) 
    ((:item-kind . "leaf") (:NAME . "schematic-or-leaf") (:IN-PINS "manifest-as-json-string") (:OUT-PINS "child-descriptor" "schematic-filename" "error") (:KIND . "schematic-or-leaf") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/schematic-or-leaf.lisp")) 
    ((:item-kind . "leaf") (:NAME . "build-graph-in-memory") (:IN-PINS "done" "json-script") (:OUT-PINS "json-collection" "error") (:KIND . "build-graph-in-memory") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/build-graph-in-memory.lisp")) 
    ((:item-kind . "leaf") (:NAME . "runner") (:IN-PINS "json-collection") (:OUT-PINS "error") (:KIND . "runner") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/runner.lisp")) 
    ((:item-kind . "graph") (:NAME . "boot-boot") 
     (:GRAPH 
      (:NAME . "BOOT-BOOT")
      (:INPUTS "SVG-FILENAME" "DONE")
      (:OUTPUTS "ERROR") 
      (:PARTS 
       ((:part-name . "COMPILER") (:KIND-NAME . "COMPILER")) 
       ((:part-name . "RUNNER") (:KIND-NAME . "RUNNER")) 
       ((:part-name . "JSON-ARRAY-SPLITTER") (:KIND-NAME . "JSON-ARRAY-SPLITTER")) 
       ((:part-name . "BUILD-GRAPH-IN-MEMORY") (:KIND-NAME . "BUILD-GRAPH-IN-MEMORY")) 
       ((:part-name . "SCHEMATIC-OR-LEAF") (:KIND-NAME . "SCHEMATIC-OR-LEAF")) 
       ((:part-name . "CHILDREN-BEFORE-GRAPH") (:KIND-NAME . "CHILDREN-BEFORE-GRAPH")) 
       ((:part-name . "GET-MANIFEST-FILE") (:KIND-NAME . "GET-MANIFEST-FILE")) 
       ((:part-name . "PART-NAMER") (:KIND-NAME . "PART-NAMER")) 
       ((:part-name . "BUILD-COLLECTOR") (:KIND-NAME . "BUILD-COLLECTOR")))
      (:WIRING 
       ((:wire-index . 0) (:SOURCES ((:PART . "COMPILER") (:PIN . "METADATA"))) (:RECEIVERS ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "ARRAY")))) 
       ((:wire-index . 1) (:SOURCES ((:PART . "COMPILER") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "SELF") (:pin . "ERROR")))) 
       ((:wire-index . 2) (:SOURCES ((:PART . "COMPILER") (:PIN . "JSON"))) (:RECEIVERS ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "JSON")))) 
       ((:wire-index . 3) (:SOURCES ((:PART . "SELF") (:PIN . "SVG-FILENAME"))) (:RECEIVERS ((:PART . "COMPILER") (:PIN . "SVG-FILENAME")) ((:PART . "PART-NAMER") (:PIN . "FILENAME")))) 
       ((:wire-index . 4) (:SOURCES ((:PART . "PART-NAMER") (:PIN . "NAME"))) (:RECEIVERS ((:PART . "CHILDREN-BEFORE-GRAPH") (:PIN . "GRAPH-NAME")))) 
       ((:wire-index . 5) (:SOURCES ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "ITEMS"))) (:RECEIVERS ((:PART . "GET-MANIFEST-FILE") (:PIN . "IN")))) 
       ((:wire-index . 6) (:SOURCES ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "GRAPH"))) (:RECEIVERS ((:PART . "CHILDREN-BEFORE-GRAPH") (:PIN . "GRAPH")))) 
       ((:wire-index . 7) (:SOURCES ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "SELF") (:pin . "ERROR")))) 
       ((:wire-index . 8) (:SOURCES ((:PART . "SCHEMATIC-OR-LEAF") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "SELF") (:pin . "ERROR")))) 
       ((:wire-index . 9) (:SOURCES ((:PART . "SCHEMATIC-OR-LEAF") (:PIN . "CHILD-DESCRIPTOR"))) (:RECEIVERS ((:PART . "CHILDREN-BEFORE-GRAPH") (:PIN . "CHILD")))) 
       ((:wire-index . 10) (:SOURCES ((:PART . "SCHEMATIC-OR-LEAF") (:PIN . "SCHEMATIC-FILENAME"))) (:RECEIVERS ((:PART . "PART-NAMER") (:PIN . "FILENAME")) ((:PART . "PART-NAMER") (:PIN . "FILENAME")))) 
       ((:wire-index . 11) (:SOURCES ((:PART . "GET-MANIFEST-FILE") (:PIN . "OUT"))) (:RECEIVERS ((:PART . "SCHEMATIC-OR-LEAF") (:PIN . "MANIFEST-AS-JSON-STRING")))) 
       ((:wire-index . 12) (:SOURCES ((:PART . "CHILDREN-BEFORE-GRAPH") (:PIN . "DESCRIPTOR"))) (:RECEIVERS ((:PART . "BUILD-COLLECTOR") (:PIN . "DESCRIPTOR")))) 
       ((:wire-index . 13) (:SOURCES ((:PART . "CHILDREN-BEFORE-GRAPH") (:PIN . "GRAPH"))) (:RECEIVERS ((:PART . "BUILD-COLLECTOR") (:PIN . "GRAPH")))) 
       ((:wire-index . 14) (:SOURCES ((:PART . "CHILDREN-BEFORE-GRAPH") (:PIN . "NAME"))) (:RECEIVERS ((:PART . "BUILD-COLLECTOR") (:PIN . "NAME")))) 
       ((:wire-index . 15) (:SOURCES ((:PART . "CHILDREN-BEFORE-GRAPH") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "SELF") (:pin . "ERROR")))) 
       ((:wire-index . 16) (:SOURCES ((:PART . "BUILD-COLLECTOR") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "SELF") (:pin . "ERROR")))) 
       ((:wire-index . 17) (:SOURCES ((:PART . "BUILD-COLLECTOR") (:PIN . "FINAL-CODE"))) (:RECEIVERS ((:PART . "BUILD-GRAPH-IN-MEMORY") (:PIN . "JSON-SCRIPT")))) 
       ((:wire-index . 18) (:SOURCES ((:PART . "BUILD-COLLECTOR") (:PIN . "DONE"))) (:RECEIVERS ((:PART . "BUILD-GRAPH-IN-MEMORY") (:PIN . "DONE")))) 
       ((:wire-index . 19) (:SOURCES ((:PART . "SELF") (:PIN . "DONE"))) (:RECEIVERS ((:PART . "BUILD-COLLECTOR") (:PIN . "DONE")))) 
       ((:wire-index . 20) (:SOURCES ((:PART . "BUILD-GRAPH-IN-MEMORY") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "ERROR")))) 
       ((:wire-index . 21) (:SOURCES ((:PART . "BUILD-GRAPH-IN-MEMORY") (:PIN . "JSON-COLLECTION"))) (:RECEIVERS ((:PART . "RUNNER") (:PIN . "JSON-COLLECTION")))) 
       ((:wire-index . 22) (:SOURCES ((:PART . "RUNNER") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "SELF") (:pin . "ERROR"))))))))
  )
