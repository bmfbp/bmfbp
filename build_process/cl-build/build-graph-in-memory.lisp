(in-package :arrowgrams/build)

(defparameter *script* nil)

(defclass build-graph-in-memory (builder) 
  ((kinds-by-name :accessor kinds-by-name)
   (code-stack :accessor code-stack)))

(defmethod e/part:busy-p ((self build-graph-in-memory))
  (call-next-method))

(defmethod e/part:clone ((self build-graph-in-memory))
  (call-next-method))

(defmethod e/part:first-time ((self build-graph-in-memory))
  (reset self))

(defmethod reset ((self build-graph-in-memory))
  (setf (kinds-by-name self) (make-hash-table :test 'equal))
  (setf (code-stack self) nil))



#|
build-graph processes ((:ITEM-KIND . "leaf") (:IN-PINS "filename") (:OUT-PINS "name" "error") (:KIND . "part-namer") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/part-namer.lisp"))

build-graph processes ((:ITEM-KIND . "leaf") (:IN-PINS "array" "json") (:OUT-PINS "items" "graph" "error") (:KIND . "json-array-splitter") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/json-array-splitter.lisp"))

build-graph processes ((:ITEM-KIND . "leaf") (:IN-PINS "in") (:OUT-PINS "out") (:KIND . "probe3") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/probe3.lisp"))

build-graph processes ((:ITEM-KIND . "graph") (:NAME . "compile-single-diagram") (:GRAPH (:NAME . "COMPILE-SINGLE-DIAGRAM") (:INPUTS "SVG-FILENAME") (:OUTPUTS "ERROR" "GRAPH" "JSON-FILE-REF" "NAME") (:PARTS ((:PART-NAME . "JSON-ARRAY-SPLITTER") (:KIND-NAME . "JSON-ARRAY-SPLITTER")) ((:PART-NAME . "PART-NAMER") (:KIND-NAME . "PART-NAMER")) ((:PART-NAME . "PROBE3") (:KIND-NAME . "PROBE3")) ((:PART-NAME . "COMPILER") (:KIND-NAME . "COMPILER"))) (:WIRING ((:WIRE-INDEX . 0) (:SOURCES ((:PART . "COMPILER") (:PIN . "METADATA"))) (:RECEIVERS ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "ARRAY")))) ((:WIRE-INDEX . 1) (:SOURCES ((:PART . "COMPILER") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "ERROR")))) ((:WIRE-INDEX . 2) (:SOURCES ((:PART . "COMPILER") (:PIN . "JSON"))) (:RECEIVERS ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "JSON")))) ((:WIRE-INDEX . 3) (:SOURCES ((:PART . "SELF") (:PIN . "SVG-FILENAME"))) (:RECEIVERS ((:PART . "PROBE3") (:PIN . "IN")))) ((:WIRE-INDEX . 4) (:SOURCES ((:PART . "PART-NAMER") (:PIN . "NAME"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "NAME")))) ((:WIRE-INDEX . 5) (:SOURCES ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "ITEMS"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "JSON-FILE-REF")))) ((:WIRE-INDEX . 6) (:SOURCES ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "GRAPH"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "GRAPH")))) ((:WIRE-INDEX . 7) (:SOURCES ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "ERROR")))) ((:WIRE-INDEX . 8) (:SOURCES ((:PART . "PROBE3") (:PIN . "OUT"))) (:RECEIVERS ((:PART . "COMPILER") (:PIN . "SVG-FILENAME")) ((:PART . "PART-NAMER") (:PIN . "FILENAME")))))))
|#

(defmethod e/part:react ((self build-graph-in-memory) e)
  ;(format *standard-output* "~&build-graph-in-memory gets ~s ~s~%" (@pin self e) (chop-str (@data self e)))
  (ecase (@pin self e)
    (:json-script
     (let ((alist (json-to-alist (@data self e))))
       (format *standard-output* "~&build-graph-in-memory pushes ~s ~s~%"
	       (cdr (assoc :item-kind alist))
	       (cdr (assoc :name alist)))
       (push alist (code-stack self))))

    (:done
     (let ((code (code-stack self)))
       (format t "~%build phase ***********~%~s~%" code)
       (process-code self (code-stack self))))))
     
(defun process-code (self list-of-alists)
  (let ((top-most-kind nil))
    (dolist (alist list-of-alists)
      (if (string= "leaf" (cdr (assoc :item-kind alist)))
          (progn
            #+nil(format *standard-output* "~&build-graph processes ~s ~s~%"
		    (get-kind alist) (cdr (assoc :name alist)))
            (build-leaf-in-mem self alist))
        (progn
          #+nil(format *standard-output* "~&build-graph processes ~s ~s~%" (get-kind alist) (cdr (assoc :name alist)))
          (setf top-most-kind (build-graph-in-mem self alist))))) ;; set top-most-kind to the last graph processed (which is the top-most, since this is being done in reverse order)
    top-most-kind))




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

#|
build-graph processes ((:ITEM-KIND . "graph") (:NAME . "compile-single-diagram") (:GRAPH (:NAME . "COMPILE-SINGLE-DIAGRAM") (:INPUTS "SVG-FILENAME") (:OUTPUTS "ERROR" "GRAPH" "JSON-FILE-REF" "NAME") (:PARTS ((:PART-NAME . "JSON-ARRAY-SPLITTER") (:KIND-NAME . "JSON-ARRAY-SPLITTER")) ((:PART-NAME . "PART-NAMER") (:KIND-NAME . "PART-NAMER")) ((:PART-NAME . "PROBE3") (:KIND-NAME . "PROBE3")) ((:PART-NAME . "COMPILER") (:KIND-NAME . "COMPILER"))) (:WIRING ((:WIRE-INDEX . 0) (:SOURCES ((:PART . "COMPILER") (:PIN . "METADATA"))) (:RECEIVERS ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "ARRAY")))) ((:WIRE-INDEX . 1) (:SOURCES ((:PART . "COMPILER") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "ERROR")))) ((:WIRE-INDEX . 2) (:SOURCES ((:PART . "COMPILER") (:PIN . "JSON"))) (:RECEIVERS ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "JSON")))) ((:WIRE-INDEX . 3) (:SOURCES ((:PART . "SELF") (:PIN . "SVG-FILENAME"))) (:RECEIVERS ((:PART . "PROBE3") (:PIN . "IN")))) ((:WIRE-INDEX . 4) (:SOURCES ((:PART . "PART-NAMER") (:PIN . "NAME"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "NAME")))) ((:WIRE-INDEX . 5) (:SOURCES ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "ITEMS"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "JSON-FILE-REF")))) ((:WIRE-INDEX . 6) (:SOURCES ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "GRAPH"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "GRAPH")))) ((:WIRE-INDEX . 7) (:SOURCES ((:PART . "JSON-ARRAY-SPLITTER") (:PIN . "ERROR"))) (:RECEIVERS ((:PART . "SELF") (:PIN . "ERROR")))) ((:WIRE-INDEX . 8) (:SOURCES ((:PART . "PROBE3") (:PIN . "OUT"))) (:RECEIVERS ((:PART . "COMPILER") (:PIN . "SVG-FILENAME")) ((:PART . "PART-NAMER") (:PIN . "FILENAME")))))))
|#

;; 
;; map incoming json -> alist -> esa KIND class, defining a graph (a diagram)
;;
(defmethod build-graph-in-mem ((self build-graph-in-memory) full-graph)
  (let ((graph (get-graph full-graph)) ;; strip noise
        (name (get-name full-graph)))
    (let ((kind (make-instance 'kind)))
      (format *standard-output* "~&define graph name ~s~%" name)
      (setf (kind-name kind) name)
      (setf (gethash name (kinds-by-name self)) kind)  ;; kind defined in esa
      (dolist (input-name (get-inputs graph))
        (add-input-pin kind (string-downcase input-name)))  ;; calls esa
      (dolist (output-name (get-outputs graph))
        (add-output-pin kind (string-downcase output-name)))  ;; calls esa
      (dolist (part-as-alist (get-parts-list graph))
        (let ((kind-name (string-downcase (get-part-kind part-as-alist)))
              (part-name (string-downcase (get-part-name part-as-alist))))
          (format *standard-output* "~&need name ~s~%" kind-name)
          (add-part kind part-name (gethash kind-name (kinds-by-name self)))))  ;; calls esa
      ;; the wiring table is an array [] of wires
      ;; each wire is defined by: 1. index, 2. (list of) sources, 3. (list of) destinations
      (dolist (wire-as-alist (get-wiring graph))
        (let ((w (make-instance 'wire)))
          (set-index w (get-wire-index wire-as-alist))
          (dolist (source (get-sources wire-as-alist))
            (add-source w (get-part source) (get-pin source)))   ;; calls esa
          (dolist (dest (get-destinations-list wire-as-alist))
            (add-destination w (get-part dest) (get-pin dest)))  ;; calls esa
          (add-wire kind w)))                                    ;; calls esa
      kind)))



(defun get-filename (a)  (cdr (assoc :filename a)))
(defun get-in-pins (a)  (cdr (assoc :in-pins a)))
(defun get-out-pins (a)  (cdr (assoc :out-pins a)))
(defun get-kind (a) (cdr (assoc :kind a)))

#|
build-graph processes ((:ITEM-KIND . "leaf") (:IN-PINS "in") (:OUT-PINS "out") (:KIND . "probe3") (:FILENAME . "/Users/tarvydas/quicklisp/local-projects/bmfbp/build_process/cl-build/probe3.lisp"))
|#

;; 
;; map incoming json -> alist -> esa KIND class, defining a leaf
;;

(defmethod build-leaf-in-mem ((self build-graph-in-memory) a)
  (let ((kind-str (get-kind a))
        (filename (get-filename a))
        (in-pins (get-in-pins a))
        (out-pins (get-out-pins a)))
    ;; kind is a CLOS class name
    (let ((kind (make-instance 'kind)))  ;; defined by esa
      (setf (kind-name kind) kind-str)
      (format *standard-output* "~&define leaf name ~s~%" kind-str)
      (when filename
        (load filename)) ;; load class into memory unless it has already been loaded (filename NIL)
      (dolist (ipin-str in-pins)
        (add-input-pin kind ipin-str))  ;; call to esa
      (dolist (opin-str out-pins)
        (add-output-pin kind opin-str)) ;; call to esa
      (setf (gethash kind-str (kinds-by-name self)) kind)  ;; this should be per diagram/graph, not global
      kind)))
