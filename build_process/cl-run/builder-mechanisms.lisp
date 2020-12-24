(in-package :arrowgrams/build)

(defmethod initialize ((self builder)) 
  (setf (table self) (make-hash-table :test 'equal)))

(defmethod get-app-from-JSON-as-map ((self builder))
  (setf (alist self) (json-to-alist (json-string self)))
  (let ((map (make-map 'string (alist self))))
    map))

(defmethod installInTable ((self builder) kind-name kind-structure)
  (setf (gethash (table self) kind-name) kind-structure))

(defmethod make-type-name ((self builder) str)
  ;; do any magic required by base language to create a type name from the string str
  ;; in Lisp, we can just use the string str - no more magic
  str)

(defmethod lookupKind ((self builder) name)
  ;; hash table lookup with key name 
  (gethash (table self) name))

(defmethod isLeaf ((self JSONpart))
  ;; internally, we keep JSONparts as ALISTs in a list (aka map)
  ;; This choice is Lisp-specific,  we might choose a different kind of representation in JS, say.  The choice is not visible at the esa.scl level - we only talk about JSONparts and maps of JSONparts, then query them using external methods
  (string= "leaf" (cdr (assoc :itemKind self))))

(defmethod isSchematic ((self JSONpart))
  (string= "graph" (cdr (assoc :itemKind self))))

(defmethod getPartKind ((self JSONpart))
  (cdr (assoc :kind self)))

(defmethod getFilename ((self JSONpart))
  (cdr (assoc :filename self)))

(defmethod getName ((self JSONpart))
  (cdr (assoc :name self)))

(defmethod getInPins ((self JSONpart))
  (make-map 'string (cdr (assoc :inPins self))))

(defmethod getOutPins ((self JSONpart))
  (make-map 'string (cdr (assoc :outPins self))))

;; schematic (graph) accessors
(defmethod getPartsList ((self JSONpart))
  (let ((json-graph (cdr (assoc :graphs self))))
    (make-map 'JSONpartNameAndKind (cdr (assoc :parts json-graph)))))

(defmethod getWireMap ((self JSONpart))
  (let ((json-graph (cdr (assoc :graphs self))))
    (make-map 'JSONpartNameAndPin (cdr (assoc :parts json-graph)))))


(defmethod getPartName ((self JSONpartNameAndKind)) ;; e.g. {"partName":"xyz","kindName":"HELLO"}
  ;; in Lisp, this is stored as a ALIST, e.g. ((:partName . "xyz") (:kindName . "HELLO"))
  (cdr (assoc :partName self)))

(defmethod getKindName ((self JSONpartNameAndKind)) ;; e.g. {"partName":"xyz","kindName":"HELLO"}
  ;; in Lisp, this is stored as a ALIST, e.g. ((:partName . "xyz") (:kindName . "HELLO"))
  (cdr (assoc :kindName self)))


(defmethod getIndex ((self JSONwire))
  (cdr (assoc :wireIndex self)))

(defmethod getSourceMap ((self JSONwire))
  (make-map 'JSONpartAndPin (cdr (assoc :sources self))))

(defmethod getDestinationMap ((self JSONwire))
  (make-map 'JSONpartAndPin (cdr (assoc :receivers self))))


;; helpers

(defun make-map (ty lis)
  (let ((map (make-instance 'stack-dsl::%map :%element-type ty)))
    (setf (stack-dsl:%ordered-list map) lis)
    map))


;;;;;;;;;;
;; example JSON
;;;;;;;;;;
#|
[
    {
	"itemKind":"leaf",
	"name":"string-join",
	"inPins":["a","b"],
	"outPins":["c","error"],
	"kind":"string-join",
	"filename":"$\/parts\/cl\/.\/string-join.lisp"
    },
    {"itemKind":"leaf","name":"world","inPins":["start"],"outPins":["s","error"],"kind":"world","filename":"$\/parts\/cl\/.\/world.lisp"},
    {"itemKind":"leaf","name":"hello","inPins":["start"],"outPins":["s","error"],"kind":"hello","filename":"$\/parts\/cl\/.\/hello.lisp"},

    {
	"itemKind":"graph",
	"name":"helloworld",
	"graph":{"name":"HELLOWORLD",
		 "inputs":["START"],
		 "outputs":["RESULT"],
		 "parts":
		 [
		     {"partName":"STRING-JOIN","kindName":"STRING-JOIN"},
		     {"partName":"WORLD","kindName":"WORLD"},
		     {"partName":"HELLO","kindName":"HELLO"}
		 ],
		 "wiring":
		 [
		     {
			 "wireIndex":0,
			 "sources":[{"part":"HELLO","pin":"S"}],
			 "receivers":
			 [
			     {"part":"STRING-JOIN","pin":"A"}
			 ]
		     },
		     {"wireIndex":1,"sources":[{"part":"WORLD","pin":"S"}],"receivers":[{"part":"STRING-JOIN","pin":"B"}]},
		     {"wireIndex":2,"sources":[{"part":"STRING-JOIN","pin":"C"}],"receivers":[{"part":"SELF","pin":"RESULT"}]},
		     {"wireIndex":3,"sources":[{"part":"SELF","pin":"START"}],"receivers":[{"part":"WORLD","pin":"START"},{"part":"HELLO","pin":"START"}]}
		 ]
		}
    }
]
|#
