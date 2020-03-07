(in-package :arrowgrams)

;; definition time routines
;;

;======  wire definition methods ======

(defmethod definition/set-source ((definition/wire self) (definition/node n) pin-name)
  (setf (source self) (make-instance 'definition/part-pin :part n :pin pin-name)))
  
(defmethod definition/add-destination ((definition/wire self) (definition/node n) pin-name)
  (push (destinations w) (make-instance 'part-pin :part n :pin pin-name)))

(defmethod query/get-source ((definition/wire self))
  (source self))

(defmethod query/get-destinations ((definition/wire self))
  (destinations self))

  
;======  kind definition methods ======

(defmethod definition/create-kind ()
  (make-instance 'esa-prototype-kind))

(defmethod definition/create-wire ()
  (make-instance 'wire))

(defmethod definition/create-part-pin (part pin)
  (definition/ensure-string-or-symbol-p part)
  (definition/ensure-string-or-symbol-p pin)
  (let ((p (make-instance 'part-pin :part part :pin pin)))
    p))

(defmethod definition/add-input-pin ((kind esa-prototype-kind) name)
  (definition/ensure-unique-input-pin-name name)
  (setf (gethash name (input-pins kind)) T))

(defmethod definition/add-output-pin ((kind esa-prototype-kind) name)
  (definition/ensure-unique-output-pin-name name)
  (setf (gethash name (input-pins kind)) T))

(defmethod definition/set-source ((wire w) part pin (esa-prototype-kind kind))
  (assert (null (source w))) ;; setting source multiple times not allowed during bootstrap
  (definition/ensure-part-exists-in-kind kind part)
  (definition/ensure-valid-source-pin kind part pin)
  (let ((part-pin (create-part-pin part pin)))
    (setf (source w) part-pin)))

(defmethod definition/add-destination-to-wire ((wire w) part pin (esa-prototype-kind kind))
  (let ((part-pin-pair (create-part-pin part pin)))
    (definition/ensure-part-exists-in-kind kind part)
    (definition/ensure-valid-destination-pin kind part pin)
    (definition/ensure-destination-does-not-exist-on-wire part-pin-pair)
    (push part-pin (destinations self))))

(defmethod definition/add-named-part ((self esa-prototype-kind) name part-kind)
  (definition/ensure-part-name-is-unique self)
  (setf (gethash name (parts self)) part-kind))

(defmethod definition/add-wire ((self esa-prototype-kind) (wire w))
  (push w (wires self)))

;;;;;;; utilitites and error checking ;;;;;;;;;

(defun definition/sequal (self other)
  (if (stringp self)
      (string= self other)
     (eql self other)))

(defmethod definition/pair-eq ((part-pin self) (part-pin other))
  (and (definition/sequal (part self) (part other))
       (definition/sequal (pin self) (pin other)))

(defmethod definition/find-destination-p ((wire w) (part-pin p))
   (mapc #'(lambda (pair)
	     (when (pair-eq pair p)
	       (return-from definition/find-destination T)))
	 (destinations w))
   nil)

(defmethod definition/ensure-destination-does-not-exist-on-wire ((wire w) (part-pin p))
  (unless (null (definition/find-destination-p w p))
    (error "destination already exists on wire ~s ~s" w p)))

(defmethod definition/ensure-part-exists-in-kind ((esa-prototype-kind kind) name)
  (multiple-value-bind (val success)
      (gethash name (parts kind))
    (declare (ignore val))
    (unless success
      (error "part ~s does not exist in kind ~s" name kind))))

(defmethod definition/ensure-part-name-is-unique ((esa-prototype-kind kind) name)
  (multiple-value-bind (val success)
      (gethash name (parts kind))
    (declare (ignore (val)))
    (when success
      (error ("~s must not be defined more than once as a part in kind ~s" name kind)))))

(defun ensure-string-or-symbol-p (x)
  (unless (or (stringp x) (symbolp x))
    (error "~s must be a string or a symbol" x)))

(defmethod definition/ensure-unique-input-pin-name ((esa-prototype-kind kind) name)
  (ensure-string-or-symbol-p name)
  (multiple-value-bind (val success) 
      (gethash name (input-pins kind))
    (declare (ignore val))
    (when success
      (error "input pin name ~s must not be defined more than once" name))))
  
(defmethod definition/ensure-unique-output-pin-name ((esa-prototype-kind kind) name)
  (ensure-string-or-symbol-p name)
  (multiple-value-bind (val success) 
      (gethash name (output-pins kind))
    (declare (ignore val))
    (when success
      (error "output pin name ~s must not be defined more than once" name))))
  
(defmethod definition/ensure-valid-source-pin ((esa-prototype-kind self) part pin)
  (if (eq pin :self)
      (definition/ensure-input-pin-name self pin)
     (definition/ensure-output-pin-name (find-kind part) pin)))

(defmethod definition/ensure-valid-destination-pin ((esa-prototype-kind self) part pin)
  (if (eq pin :self)
      (defininition/ensure-output-pin-name self pin)
     (definition/ensure-input-pin-name (find-kind part) pin)))

(defmethod definition/ensure-input-pin-name ((esa-prototype-kind kind) name)
  (unless (member name (input-pins kind))
    (error "~s must be an input pin of kind ~s" name kind)))

(defmethod definition/ensure-output-pin-name ((esa-prototype-kind kind) name)
  (unless (member name (output-pins kind))
    (error "~s must be an output pin of kind ~s" name kind)))
