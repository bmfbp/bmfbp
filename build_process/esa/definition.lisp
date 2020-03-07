(in-package :arrowgrams)

;; definition time routines
;;
;; routines which flesh out the prototype Kinds

(defmethod create-kind ()
  (make-instance 'esa-prototype-kind))

(defmethod create-wire ()
  (make-instance 'wire))

(defmethod create-part-pin (part pin)
  (ensure-string-or-symbol-p part)
  (ensure-string-or-symbol-p pin)
  (let ((p (make-instance 'part-pin :part part :pin pin)))
    p))

(defmethod add-input-pin ((kind esa-prototype-kind) name)
  (ensure-unique-input-pin-name name)
  (setf (gethash name (input-pins kind)) T))

(defmethod add-output-pin ((kind esa-prototype-kind) name)
  (ensure-unique-output-pin-name name)
  (setf (gethash name (input-pins kind)) T))

(defmethod set-source ((wire w) part pin (esa-prototype-kind kind))
  (assert (null (source w))) ;; setting source multiple times not allowed during bootstrap
  (ensure-part-exists-in-kind kind part)
  (ensure-valid-source-pin kind part pin)
  (let ((part-pin (create-part-pin part pin)))
    (setf (source w) part-pin)))

(defmethod add-destination-to-wire ((wire w) part pin (esa-prototype-kind kind))
  (let ((part-pin-pair (create-part-pin part pin)))
    (ensure-part-exists-in-kind kind part)
    (ensure-valid-destination-pin kind part pin)
    (ensure-destination-does-not-exist-on-wire part-pin-pair)
    (push part-pin (destinations self))))

(defmethod add-named-part ((self esa-prototype-kind) name part-kind)
  (ensure-part-name-is-unique self)
  (setf (gethash name (parts self)) part-kind))


;;;;;;; utilitites an error checking ;;;;;;;;;

(defun sequal (self other)
  (if (stringp self)
      (string= self other)
     (eql self other)))

(defmethod pair-eq ((part-pin self) (part-pin other))
  (and (sequal (part self) (part other))
       (sequal (pin self) (pin other)))

(defmethod find-destination-p ((wire w) (part-pin p))
   (mapc #'(lambda (pair)
	     (when (pair-eq pair p)
	       (return-from find-destination T)))
	 (destinations w))
   nil)

(defmethod ensure-destination-does-not-exist-on-wire ((wire w) (part-pin p))
  (unless (null (find-destination-p w p))
    (error "destination already exists on wire ~s ~s" w p)))

(defmethod ensure-part-exists-in-kind ((esa-prototype-kind kind) name)
  (multiple-value-bind (val success)
      (gethash name (parts kind))
    (declare (ignore val))
    (unless success
      (error "part ~s does not exist in kind ~s" name kind))))

(defmethod ensure-part-name-is-unique ((esa-prototype-kind kind) name)
  (multiple-value-bind (val success)
      (gethash name (parts kind))
    (declare (ignore (val)))
    (when success
      (error ("~s must not be defined more than once as a part in kind ~s" name kind)))))

(defun ensure-string-or-symbol-p (x)
  (unless (or (stringp x) (symbolp x))
    (error "~s must be a string or a symbol" x)))

(defmethod ensure-unique-input-pin-name ((esa-prototype-kind kind) name)
  (ensure-string-or-symbol-p name)
  (multiple-value-bind (val success) 
      (gethash name (input-pins kind))
    (declare (ignore val))
    (when success
      (error "input pin name ~s must not be defined more than once" name))))
  
(defmethod ensure-unique-output-pin-name ((esa-prototype-kind kind) name)
  (ensure-string-or-symbol-p name)
  (multiple-value-bind (val success) 
      (gethash name (output-pins kind))
    (declare (ignore val))
    (when success
      (error "output pin name ~s must not be defined more than once" name))))
  
(defmethod ensure-valid-source-pin ((esa-prototype-kind self) part pin)
  (if (eq pin :self)
      (ensure-input-pin-name self pin)
     (ensure-output-pin-name (find-kind part) pin)))

(defmethod ensure-valid-destination-pin ((esa-prototype-kind self) part pin)
  (if (eq pin :self)
      (ensure-output-pin-name self pin)
     (ensure-input-pin-name (find-kind part) pin)))

(defmethod ensure-input-pin-name ((esa-prototype-kind kind) name)
  (unless (member name (input-pins kind))
    (error "~s must be an input pin of kind ~s" name kind)))

(defmethod ensure-output-pin-name ((esa-prototype-kind kind) name)
  (unless (member name (output-pins kind))
    (error "~s must be an output pin of kind ~s" name kind)))
