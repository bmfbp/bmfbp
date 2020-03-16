(in-package :arrowgrams/build)

(defparameter *script* nil)

(defclass build-graph-in-memory (builder) 
  ((kinds-by-name :accessor kinds-by-name)))

(defmethod e/part:busy-p ((self build-graph-in-memory))
  (call-next-method))

(defmethod e/part:clone ((self build-graph-in-memory))
  (call-next-method))

(defmethod e/part:first-time ((self build-graph-in-memory))
  (setf (kinds-by-name self) (make-hash-table :test 'equal)))

(defmethod e/part:react ((self build-graph-in-memory) e)
  (ecase (@pin self e)
    (:json-script
     (let ((script-as-alist (json-to-alist (@data self e))))
       (setf *script* script-as-alist)
       (alist-to-graph self script-as-alist)))))
         ;(@send self :tree root))))))

(defmethod alist-to-graph ((self build-graph-in-memory) script-as-alist)
  (dolist (a script-as-alist)
    (let ((item-kind (get-item-kind a))
          (name  (get-name a)))
      (if (string= "graph" item-kind)
          (build-graph-in-mem self name a)
        (build-leaf-in-mem self name a)))))




#|
{"Itemkind":"graph",
 "name":"ide",
 "graph":{
     "name":"IDE",
     "inputs":null,
     "outputs":null,
     "parts":[{"partName":"RUN",
	       "kindName":"RUN"},
	      {"partName":"SVG-INPUT",
	       "kindName":"SVG-INPUT"},
	      {"partName":"TOP-LEVEL-NAME",
	       "kindName":"TOP-LEVEL-NAME"},
	      {"partName":"BUILD-PROCESS",
	       "kindName":"BUILD-PROCESS"}],
     "wiring":[{"wireIndex":0,
		"sources":[{"part":"SVG-INPUT",
			    "pin":"SVG-CONTENT"}],
		"receivers":[{"part":"BUILD-PROCESS",
			      "pin":"TOP-LEVEL-SVG"}]},
	       {"wireIndex":1,
		"sources":[{"part":"BUILD-PROCESS",
			    "pin":"JAVASCRIPT-SOURCE-CODE"}],
		"receivers":[{"part":"RUN",
			      "pin":"IN"}]},
	       {"wireIndex":2,
		"sources":[{"part":"TOP-LEVEL-NAME",
			    "pin":"NAME"}],
		"receivers":[{"part":"BUILD-PROCESS",
			      "pin":"TOP-LEVEL-NAME"}]}]}},
|#

#|

(json-to-alist "{\"itemKind\":\"graph\",\"name\":\"ide\",\"graph\":{\"name\":\"IDE\",\"inputs\":null,\"outputs\":null,\"parts\":[{\"partName\":\"RUN\",\"kindName\":\"RUN\"},{\"partName\":\"SVG-INPUT\",\"kindName\":\"SVG-INPUT\"},{\"partName\":\"TOP-LEVEL-NAME\",\"kindName\":\"TOP-LEVEL-NAME\"},{\"partName\":\"BUILD-PROCESS\",\"kindName\":\"BUILD-PROCESS\"}],\"wiring\":[{\"wireIndex\":0,\"sources\":[{\"part\":\"SVG-INPUT\",\"pin\":\"SVG-CONTENT\"}],\"receivers\":[{\"part\":\"BUILD-PROCESS\",\"pin\":\"TOP-LEVEL-SVG\"}]},{\"wireIndex\":1,\"sources\":[{\"part\":\"BUILD-PROCESS\",\"pin\":\"JAVASCRIPT-SOURCE-CODE\"}],\"receivers\":[{\"part\":\"RUN\",\"pin\":\"IN\"}]},{\"wireIndex\":2,\"sources\":[{\"part\":\"TOP-LEVEL-NAME\",\"pin\":\"NAME\"}],\"receivers\":[{\"part\":\"BUILD-PROCESS\",\"pin\":\"TOP-LEVEL-NAME\"}]}]}}")

((:ITEM-KIND . "graph") (:NAME . "ide") (:GRAPH (:NAME . "IDE") (:INPUTS) (:OUTPUTS) (:PARTS ((:PART-NAME . "RUN") (:KIND-NAME . "RUN")) ((:PART-NAME . "SVG-INPUT") (:KIND-NAME . "SVG-INPUT")) ((:PART-NAME . "TOP-LEVEL-NAME") (:KIND-NAME . "TOP-LEVEL-NAME")) ((:PART-NAME . "BUILD-PROCESS") (:KIND-NAME . "BUILD-PROCESS"))) (:WIRING ((:WIRE-INDEX . 0) (:SOURCES ((:PART . "SVG-INPUT") (:PIN . "SVG-CONTENT"))) (:RECEIVERS ((:PART . "BUILD-PROCESS") (:PIN . "TOP-LEVEL-SVG")))) ((:WIRE-INDEX . 1) (:SOURCES ((:PART . "BUILD-PROCESS") (:PIN . "JAVASCRIPT-SOURCE-CODE"))) (:RECEIVERS ((:PART . "RUN") (:PIN . "IN")))) ((:WIRE-INDEX . 2) (:SOURCES ((:PART . "TOP-LEVEL-NAME") (:PIN . "NAME"))) (:RECEIVERS ((:PART . "BUILD-PROCESS") (:PIN . "TOP-LEVEL-NAME")))))))

|#

(defun get-name (alist)
  (cdr (assoc :name alist)))

(defun get-item-kind (alist)
  (cdr (assoc :item-kind alist)))

(defun get-graph (alist)
  (cdr (assoc :graph alist)))

(defun get-leaf (alist)
  (cdr (assoc :leaf alist)))

(defun get-inputs (graph-alist)
  (cdr (assoc :inputs graph-alist)))

(defun get-outputs (graph-alist)
  (cdr (assoc :outputs graph-alist)))

(defun get-parts-list (graph-alist)
  (cdr (assoc :parts graph-alist)))

(defun get-part-name (part-alist)
  (cdr (assoc :part-name part-alist)))

(defun get-part-kind (part-alist)
  (cdr (assoc :kind-name part-alist)))

(defun get-wiring (graph-alist)
  (cdr (assoc :wiring graph-alist)))

(defun get-wire-index (wire-alist)
  (cdr (assoc :wire-index wire-alist)))

(defun get-sources (wire-alist)
  (cdr (assoc :sources wire-alist)))

(defun get-destinations-list (wire-alist)
  (cdr (assoc :receivers wire-alist)))

(defun get-part (x)
  (string-downcase (cdr (assoc :part x))))

(defun get-pin (x)
  (string-downcase (cdr (assoc :pin x))))

(defun strip-manifest-from-name (n)
  (let ((index (search ".manifest" n)))
    (if (numberp index)
        (subseq n 0 index)
      n)))


(defmethod build-graph-in-mem ((self build-graph-in-memory) name full-graph)
  (let ((graph (get-graph full-graph))) ;; strip noise
    (let ((kind (make-instance 'kind)))
      (format *standard-output* "~&define graph name ~s~%" name)
      (setf (kind-name kind) name)
      (setf (gethash name (kinds-by-name self)) kind)
      (dolist (input-name (get-inputs graph))
        (add-input-pin kind input-name))
      (dolist (output-name (get-outputs graph))
        (add-output-pin kind output-name))
      (dolist (part-as-alist (get-parts-list graph))
        (let ((kind-name (string-downcase (get-part-kind part-as-alist)))
              (part-name (string-downcase (get-part-name part-as-alist))))
          (format *standard-output* "~&need name ~s~%" kind-name)
          (add-part kind part-name (gethash kind-name (kinds-by-name self)))))
      ;; the wiring table is an array [] of wires
      ;; each wire is defined by: 1. index, 2. (list of) sources, 3. (list of) destinations
      (dolist (wire-as-alist (get-wiring graph))
        (let ((w (make-instance 'wire)))
          (set-index w (get-wire-index wire-as-alist))
          (dolist (source (get-sources wire-as-alist))
            (add-source w (get-part source) (get-pin source)))
          (dolist (dest (get-destinations-list wire-as-alist))
            (add-destination w (get-part dest) (get-pin dest)))
          (add-wire kind w)))
      kind)))

(defun get-file-name (a)
  (cdr (assoc :file-name a)))

(defun get-in-pins (a)
  (cdr (assoc :in-pins a)))

(defun get-out-pins (a)
  (cdr (assoc :out-pins a)))

(defmethod build-leaf-in-mem ((self build-graph-in-memory) manifest-name leaf-as-alist)
  (let ((name (string-downcase (strip-manifest-from-name manifest-name))))
(format *standard-output* "~&define leaf name ~s~%" name)
    (let ((filename (get-file-name leaf-as-alist)))
      (let ((json-str (alexandria:read-file-into-string filename)))
        (let ((manifest-as-alist (json-to-alist json-str)))
          (let ((kind (make-instance 'kind))
                (in-pins (get-in-pins manifest-as-alist))
                (out-pins (get-out-pins manifest-as-alist)))
            (setf (kind-name kind) name)
            (dolist (ipin in-pins)
              (add-input-pin kind ipin))
            (dolist (opin out-pins)
              (add-output-pin kind opin))
            (setf (gethash name (kinds-by-name self)) kind)
            leaf-as-alist ))))))


(defparameter *test-graph*
  '(
    ((:item-kind . "leaf") (:NAME . "split_diagram") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/split_diagram.lisp")) 
    ((:item-kind . "leaf") (:NAME . "compile_one_diagram") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/compile_one_diagram.lisp")) 
    ((:item-kind . "leaf") (:NAME . "json_array_splitter") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/json_array_splitter.lisp")) 
    ((:item-kind . "graph") (:NAME . "compile_composite") (:GRAPH (:NAME . "COMPILE_COMPOSITE") (:INPUTS) (:OUTPUTS) (:PARTS ((:PART-NAME . "SPLIT-DIAGRAM") (:KIND-NAME . "SPLIT-DIAGRAM")) ((:PART-NAME . "COMPILE-ONE-DIAGRAM") (:KIND-NAME . "COMPILE-ONE-DIAGRAM")) ((:PART-NAME . "JSON-ARRAY-SPLITTER") (:KIND-NAME . "JSON-ARRAY-SPLITTER"))) (:WIRING ((:WIRE-INDEX . 0) (:SOURCES ((:PART . "SPLIT-DIAGRAM") (:PIN . "DIAGRAM"))) (:RECEIVERS ((:PART . "COMPILE-ONE-DIAGRAM") (:PIN . "DIAGRAM")))) ((:WIRE-INDEX . 1) (:SOURCES ((:PART . "SPLIT-DIAGRAM") (:PIN . "METADATA-AS-JSON-ARRAY"))) (:RECEIVERS ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "JSON")))) ((:WIRE-INDEX . 2) (:SOURCES ((:PART . "SELF") (:PIN . "SVG"))) (:RECEIVERS ((:PART . "SPLIT-DIAGRAM") (:PIN . "SVG-CONTENT")))) ((:WIRE-INDEX . 3) (:SOURCES ((:PART . "COMPILE-ONE-DIAGRAM") (:PIN . "GRAPH-AS-JSON"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "GRAPH-AS-JSON")))) ((:WIRE-INDEX . 4) (:SOURCES ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "OBJECTS"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "PARTS-AS-JSON-OBJECTS")))))))

    ((:ITEM-KIND . "leaf") (:NAME . "get_file_content_in_repo") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/get_file_content_in_repo.lisp"))
    ((:ITEM-KIND . "leaf") (:NAME . "iterator") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/iterator.lisp"))
    ((:ITEM-KIND . "leaf") (:NAME . "json_object_stacker") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/json_object_stacker.lisp"))
    ((:ITEM-KIND . "leaf") (:NAME . "determine_kind_type") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/determine_kind_type.lisp"))
    ((:ITEM-KIND . "leaf") (:NAME . "collector") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/collector.lisp"))
    ((:ITEM-KIND . "leaf") (:NAME . "javascript_builder") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/javascript_builder.lisp"))
    ((:ITEM-KIND . "leaf") (:NAME . "fetch_git_repo") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/fetch_git_repo.lisp"))
    ((:item-kind . "leaf") (:NAME . "prepare_temp_directory") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/prepare_temp_directory.lisp")) 
    ((:item-kind . "graph") (:NAME . "build_process") (:GRAPH (:NAME . "BUILD_PROCESS") (:INPUTS) (:OUTPUTS) (:PARTS ((:PART-NAME . "DETERMINE-KINDTYPE") (:KIND-NAME . "DETERMINE-KINDTYPE")) ((:PART-NAME . "COLLECTOR") (:KIND-NAME . "COLLECTOR")) ((:PART-NAME . "GET-FILE-CONTENT-IN-REPO") (:KIND-NAME . "GET-FILE-CONTENT-IN-REPO")) ((:PART-NAME . "FETCH-GIT-REPO") (:KIND-NAME . "FETCH-GIT-REPO")) ((:PART-NAME . "GET-FILE-CONTENT-IN-REPO") (:KIND-NAME . "GET-FILE-CONTENT-IN-REPO")) ((:PART-NAME . "COMPILE-COMPOSITE") (:KIND-NAME . "COMPILE-COMPOSITE")) ((:PART-NAME . "PREPARE-TEMP-DIRECTORY") (:KIND-NAME . "PREPARE-TEMP-DIRECTORY")) ((:PART-NAME . "JAVASCRIPT-BUILDER") (:KIND-NAME . "JAVASCRIPT-BUILDER")) ((:PART-NAME . "ITERATOR") (:KIND-NAME . "ITERATOR")) ((:PART-NAME . "JSON-OBJECT-STACKER") (:KIND-NAME . "JSON-OBJECT-STACKER"))) (:WIRING ((:WIRE-INDEX . 0) (:SOURCES ((:PART . "JSON-OBJECT-STACKER") (:PIN . "PART-METADATA"))) (:RECEIVERS ((:PART . "FETCH-GIT-REPO") (:PIN . "GIT-REPO-METADATA")) ((:PART . "ITERATOR") (:PIN . "CONTINUE")))) ((:WIRE-INDEX . 1) (:SOURCES ((:PART . "COMPILE-COMPOSITE") (:PIN . "PARTS-AS-JSON-OBJECTS"))) (:RECEIVERS ((:PART . "JSON-OBJECT-STACKER") (:PIN . "PUSH-OBJECT")))) ((:WIRE-INDEX . 2) (:SOURCES ((:PART . "COMPILE-COMPOSITE") (:PIN . "GRAPH-AS-JSON"))) (:RECEIVERS ((:PART . "COLLECTOR") (:PIN . "COMPOSITE")))) ((:WIRE-INDEX . 3) (:SOURCES ((:PART . "COLLECTOR") (:PIN . "INTERMEDIATE-CODE"))) (:RECEIVERS ((:PART . "JAVASCRIPT-BUILDER") (:PIN . "INTERMEDIATE-CODE")))) ((:WIRE-INDEX . 4) (:SOURCES ((:PART . "ITERATOR") (:PIN . "GET-A-PART"))) (:RECEIVERS ((:PART . "JSON-OBJECT-STACKER") (:PIN . "GET-A-PART")))) ((:WIRE-INDEX . 5) (:SOURCES ((:PART . "JSON-OBJECT-STACKER") (:PIN . "NO-MORE"))) (:RECEIVERS ((:PART . "ITERATOR") (:PIN . "DONE")) ((:PART . "COLLECTOR") (:PIN . "DONE")))) ((:WIRE-INDEX . 6) (:SOURCES ((:PART . "DETERMINE-KINDTYPE") (:PIN . "PART-METADATA"))) (:RECEIVERS ((:PART . "GET-FILE-CONTENT-IN-REPO") (:PIN . "GIT-REPO-METADATA")))) ((:WIRE-INDEX . 7) (:SOURCES ((:PART . "DETERMINE-KINDTYPE") (:PIN . "LEAF-METADATA"))) (:RECEIVERS ((:PART . "COLLECTOR") (:PIN . "LEAF")))) ((:WIRE-INDEX . 8) (:SOURCES ((:PART . "GET-FILE-CONTENT-IN-REPO") (:PIN . "FILE-CONTENT"))) (:RECEIVERS ((:PART . "COMPILE-COMPOSITE") (:PIN . "SVG")))) ((:WIRE-INDEX . 9) (:SOURCES ((:PART . "SELF") (:PIN . "TOP-LEVEL-SVG"))) (:RECEIVERS ((:PART . "ITERATOR") (:PIN . "START")) ((:PART . "COMPILE-COMPOSITE") (:PIN . "SVG")))) ((:WIRE-INDEX . 10) (:SOURCES ((:PART . "JAVASCRIPT-BUILDER") (:PIN . "TOP-LEVEL-NAME"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "JAVASCRIPT-SOURCE-CODE")))) ((:WIRE-INDEX . 11) (:SOURCES ((:PART . "FETCH-GIT-REPO") (:PIN . "METADATA"))) (:RECEIVERS ((:PART . "GET-FILE-CONTENT-IN-REPO") (:PIN . "GIT-REPO-METADATA")))) ((:WIRE-INDEX . 12) (:SOURCES ((:PART . "PREPARE-TEMP-DIRECTORY") (:PIN . "DIRECTORY"))) (:RECEIVERS ((:PART . "GET-FILE-CONTENT-IN-REPO") (:PIN . "TEMP-DIRECTORY")) ((:PART . "GET-FILE-CONTENT-IN-REPO") (:PIN . "TEMP-DIRECTORY")) ((:PART . "FETCH-GIT-REPO") (:PIN . "TEMP-DIRECTORY")) ((:PART . "JAVASCRIPT-BUILDER") (:PIN . "TEMP-DIRECTORY")))) ((:WIRE-INDEX . 13) (:SOURCES ((:PART . "GET-FILE-CONTENT-IN-REPO") (:PIN . "FILE-CONTENT"))) (:RECEIVERS ((:PART . "DETERMINE-KINDTYPE") (:PIN . "FILE-CONTENT")))) ((:WIRE-INDEX . 14) (:SOURCES ((:PART . "GET-FILE-CONTENT-IN-REPO") (:PIN . "METADATA"))) (:RECEIVERS ((:PART . "DETERMINE-KINDTYPE") (:PIN . "PART-METADATA")))) ((:WIRE-INDEX . 15) (:SOURCES ((:PART . "SELF") (:PIN . "TOP-LEVEL-NAME"))) (:RECEIVERS ((:PART . "JAVASCRIPT-BUILDER") (:PIN . "TOP-LEVEL-NAME")))))))


    ((:ITEM-KIND . "leaf") (:NAME . "svg_input") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/svg_input.lisp"))
    ((:ITEM-KIND . "leaf") (:NAME . "run") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/run.lisp"))
    ((:ITEM-KIND . "leaf") (:NAME . "top_level_name") (:FILE-NAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/lispparts/top_level_name.lisp")) 
    ((:ITEM-KIND . "graph") (:NAME . "ide") (:GRAPH (:NAME . "IDE") (:INPUTS) (:OUTPUTS) (:PARTS ((:PART-NAME . "SVG-INPUT") (:KIND-NAME . "SVG-INPUT")) ((:PART-NAME . "TOP-LEVEL-NAME") (:KIND-NAME . "TOP-LEVEL-NAME")) ((:PART-NAME . "BUILD-PROCESS") (:KIND-NAME . "BUILD-PROCESS")) ((:PART-NAME . "RUN") (:KIND-NAME . "RUN"))) (:WIRING ((:WIRE-INDEX . 0) (:SOURCES ((:PART . "SVG-INPUT") (:PIN . "SVG-CONTENT"))) (:RECEIVERS ((:PART . "BUILD-PROCESS") (:PIN . "TOP-LEVEL-SVG")))) ((:WIRE-INDEX . 1) (:SOURCES ((:PART . "BUILD-PROCESS") (:PIN . "JAVASCRIPT-SOURCE-CODE"))) (:RECEIVERS ((:PART . "RUN") (:PIN . "IN")))) ((:WIRE-INDEX . 2) (:SOURCES ((:PART . "TOP-LEVEL-NAME") (:PIN . "NAME"))) (:RECEIVERS ((:PART . "BUILD-PROCESS") (:PIN . "TOP-LEVEL-NAME")))))))

    ))

(defun cl-user::bg ()
  (let ((obj (make-instance 'build-graph-in-memory)))
    (e/part:first-time obj)
    (arrowgrams/build::alist-to-graph obj *test-graph*)))