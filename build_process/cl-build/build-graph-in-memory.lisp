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
       (dolist (a script-as-alist)
         (let ((item-kind (get-item-kind a))
               (name  (get-name a)))
           (if (string= "graph" item-kind)
               (build-graph-in-mem self name a)
             (build-leaf-in-mem self name a))))))))
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
  (cdr (assoc :wireindex wire-alist)))

(defun get-sources (wire-alist)
  (cdr (assoc :sources wire-alist)))

(defun get-destinations-list (wire-alist)
  (cdr (assoc :recievers wire-alist)))

(defun get-part (x)
  (cdr (assoc :part x)))

(defun get-pin (x)
  (cdr (assoc :pin x)))


(defmethod build-graph-in-mem ((self build-graph-in-memory) name full-graph)
  (let ((graph (get-graph full-graph))) ;; strip noise
    (let ((kind (make-instance 'kind)))
(format *standard-output* "~&define name ~s~%" name)
      (setf (kind-name kind) name)
      (setf (gethash name (kinds-by-name self)) kind)
      (dolist (input-name (get-inputs graph))
        (add-input-pin kind input-name))
      (dolist (output-name (get-outputs graph))
        (add-output-pin kind output-name))
      (dolist (part-as-alist (get-parts-list graph))
(format *standard-output* "~&need name ~s~%" (get-part-kind part-as-alist))
        (add-part kind (get-part-name part-as-alist) (gethash (get-part-kind part-as-alist) (kinds-by-name self)))
        ;; the root wiring table is an array [] of wires
        ;; each wire is defined by: 1. index, 2. (list of) sources, 3. (list of) destinations
        (dolist (wire-as-alist (get-wiring graph))
          (let ((w (make-instance 'wire)))
            (set-index w (get-wire-index wire-as-alist))
            (dolist (source (get-sources wire-as-alist))
              (add-source w (get-part source) (get-pin source)))
            (dolist (dest (get-destinations-list wire-as-alist))
              (add-destination w (get-part dest) (get-pin dest)))
            (add-wire kind w)))
        kind))))

(defmethod build-leaf-in-mem ((self build-graph-in-memory) name leaf-as-alist)
  (let ((kind (make-instance 'kind)))
(format *standard-output* "~&define name ~s~%" name)
    (setf (kind-name kind) name)
    (setf (gethash name (kinds-by-name self)) kind)
    leaf-as-alist ))

