(in-package :arrowgrams/build)

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

(defun get-sources (wire-alist)
  (cdr (assoc :sources wire-alist)))

(defun get-destinations-list (wire-alist)
  (cdr (assoc :recievers wire-alist)))


(defun build-graph-in-memory (graph-as-alist)
  (let ((graph (get-graph graph-as-alist))) ;; get rid of headers :item-kind, :name, :graph
    (let ((node (create-definition/node)))
      (dolist (i (get-inputs graph))
        (add-input-pin node i))
      (dolist (o (get-outputs graph))
        (add-output-pin node o))
      (dolist (p (get-parts-list graph))
        (add-part node (list (get-part-name p) (get-part-kind p))))
      (dolist (wire-alist (get-wiring graph))
        (let ((w (create-definition/wire)))
          (dolist (source (get-sources wire-alist))
            (add-source w source)
            (dolist (dest (get-destinations-list wire-alist))
              (add-destination w dest))
            (install-wire node w)))))))
                          
