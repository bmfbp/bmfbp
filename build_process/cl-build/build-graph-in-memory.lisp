(in-package :arrowgrams/build)

(defclass build-graph-in-memory (builder) ())

(defmethod e/part:busy-p ((self build-graph-in-memory))
  (call-next-method))

(defmethod e/part:clone ((self build-graph-in-memory))
  (call-next-method))

(defmethod e/part:first-time ((self build-graph-in-memory))
)

(defmethod e/part:react ((self build-graph-in-memory) e)
  (ecase (@pin self e)
    (:json-script
     (let ((script-as-alist (json-to-alist (@data self e))))
       (dolist (a script-as-alist)
         (let ((graph (get-graph a))
               (leaf  (get-leaf a)))
           (if graph
               (build-graph-in-mem graph)
             (build-leaf-in-mem leaf))))))))
         ;(@send self :tree root))))))



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

(defun json-to-alist (json-string)
  (with-input-from-string (s json-string)
    (json:decode-json s)))

(defun alist-to-json (alist)
  (json:encode-json-alist-to-string alist))

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
  (cdr (assoc :wireindex wire-alist)))

(defun get-sources (wire-alist)
  (cdr (assoc :sources wire-alist)))

(defun get-destinations-list (wire-alist)
  (cdr (assoc :recievers wire-alist)))

(defun get-part (x)
  (cdr (assoc :part x)))

(defun get-pin (x)
  (cdr (assoc :pin x)))


(defun build-graph-in-mem (graph)
  (let ((root-kind (make-instance 'kind)))
    (dolist (input-name (get-inputs graph))
      (add-input-pin root-kind input-name))
    (dolist (output-name (get-outputs graph))
      (add-output-pin root-kind output-name))
    (dolist (part-kind (get-parts-list graph))
      (add-part root-kind part-kind part-kind)) ;; for bootstrap part-kind == part-name
    ;; the root wiring table is an array [] of wires
    ;; each wire is defined by: 1. index, 2. (list of) sources, 3. (list of) destinations
    (dolist (wire-as-alist (get-wiring graph))
      (let ((w (make-instance 'wire)))
        (set-index w (get-wire-index wire-as-alist))
        (dolist (source (get-sources wire-as-alist))
          (add-source w (get-part source) (get-pin source)))
        (dolist (dest (get-destinations-list wire-as-alist))
          (add-destination w (get-part dest) (get-pin dest)))
        (add-wire root-kind w)))
    root-kind))

(defun build-leaf-in-mem (leaf-as-alist)
  leaf-as-alist )

