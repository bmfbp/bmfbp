(in-package :arrowgrams/build)

(defclass loader ()
  ((kinds-by-name :accessor kinds-by-name)
   (code-stack :accessor code-stack)))


(defun make-kind-from-graph (alist)
  ;; kind is defined in esa.lisp
  (let ((self (make-instance 'loader)))
    (setf (kinds-by-name self) (make-hash-table :test 'equal))
    (setf (code-stack self) nil)
    (let ((top-kind (process-array-of-alists self alist)))
      top-kind)))



(defmethod process-array-of-alists ((self loader) list-of-alists)
  (let ((top-most-kind nil))
    (dolist (alist list-of-alists)
      (if (string= "leaf" (cdr (assoc :item-kind alist)))
          (progn
            #+nil(format *standard-output* "~&build-graph processes ~s ~s~%"
		    (get-kind alist) (cdr (assoc :name alist)))
            (process-leaf self alist))
        (progn
          #+nil(format *standard-output* "~&build-graph processes ~s ~s~%" (get-kind alist) (cdr (assoc :name alist)))
          (setf top-most-kind (process-graph self alist))))) ;; set top-most-kind to the last graph processed (which is the top-most, since this is being done in reverse order)
    top-most-kind))



(defmethod process-graph ((self loader) full-graph)
  (let ((graph (get-graph full-graph)) ;; strip noise
        (name (get-name full-graph)))
    (let ((kind (make-instance 'kind)))
      (let ((kind-sym 'graph))
        (setf (kind-name kind) name)
        (setf (self-class kind) kind-sym)
        (setf (gethash kind-sym (kinds-by-name self)) kind)  ;; kind defined in esa
        (dolist (input-name (get-inputs graph))
          (add-input-pin kind (make-pin-name input-name)))  ;; calls esa
        (dolist (output-name (get-outputs graph))
          (add-output-pin kind (string-downcase output-name)))  ;; calls esa
        (dolist (part-as-alist (get-parts-list graph))
          (let ((kind-sym (make-class-name (get-part-kind part-as-alist)))
                (part-name (make-pin-name (get-part-name part-as-alist))))
            (add-part kind part-name (gethash kind-sym (kinds-by-name self)) kind-sym)))  ;; calls esa
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
        kind))))
  


(defmethod process-leaf ((self loader) a)
  (let ((kind-str (get-kind a))
        (filename (get-filename a))
        (in-pins (get-in-pins a))
        (out-pins (get-out-pins a)))
    ;; kind is a CLOS class name
    (let ((kind-sym (make-class-name kind-str)))
      (let ((k (make-instance 'kind)))  ;; defined by esa
        (setf (kind-name k) kind-sym)
        (setf (self-class k) kind-sym)
        (when filename
          (load filename)) ;; load class into memory unless it has already been loaded (filename NIL)
        (dolist (ipin-str in-pins)
          (add-input-pin k ipin-str))  ;; call to esa
        (dolist (opin-str out-pins)
          (add-output-pin k opin-str)) ;; call to esa
        (setf (gethash kind-sym (kinds-by-name self)) k)  ;; this should be per diagram/graph, not global
        k))))


;; utility functions and dealing with CL packages

(defparameter *arrowgrams-package* "ARROWGRAMS/BUILD")

(defun make-class-name (str)
  (intern (string-upcase str) *arrowgrams-package*))

(defun make-pin-name (str)
  (string-downcase str))

(defun make-part-id (str)
  (string-downcase str))




;;;;;;;; lisp routines to access alists (from JSON)
;;;;;;;; used for building GRAPH

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

;;;;;;;; lisp routines to access alists (from JSON)
;;;;;;;; used for building LEAF

(defun get-filename (a)  (fixup-root-reference (cdr (assoc :filename a))))
(defun get-in-pins (a)  (cdr (assoc :in-pins a)))
(defun get-out-pins (a)  (cdr (assoc :out-pins a)))
(defun get-kind (a) (cdr (assoc :kind a)))

