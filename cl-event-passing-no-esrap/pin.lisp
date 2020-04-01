(in-package :e/pin)

(defclass pin ()
  ((pin-name :accessor pin-name :initarg :pin-name)
   (pin-parent :accessor pin-parent :initarg :pin-parent)
   (debug-name :accessor debug-name :initarg :debug-name :initform "")))
  
(defclass input-pin (pin) ())

(defclass output-pin (pin) ())

(defmethod print-object ((obj input-pin) out)
  (format out "<input-pin[~a/~S/~a]>" (e/part::name (pin-parent obj)) (pin-name obj) (debug-name obj)))

(defmethod print-object ((obj output-pin) out)
  (format out "<output-pin[~a/~S/~a]>" (e/part::name (pin-parent obj)) (pin-name obj) (debug-name obj)))

(defmethod clone-with-part (cloned-part (proto input-pin))
  (make-instance 'input-pin
                 :pin-name (pin-name proto)
                 :pin-parent cloned-part
                 :debug-name (format nil "cloned input pin ~S" (debug-name proto))))

(defmethod clone-with-part (cloned-part (proto output-pin))
  (make-instance 'output-pin
                 :pin-name (pin-name proto)
                 :pin-parent cloned-part
                 :debug-name (format nil "cloned output pin ~S" (debug-name proto))))

(defmethod dup-pin (proto-self proto-map cloned-self cloned-map (proto-pin input-pin))
  (let ((proto-part (pin-parent proto-pin)))
    (let ((cloned-part (e/part::map-part proto-self proto-map cloned-self cloned-map (pin-parent proto-pin))))
      (e/part::get-input-pin cloned-part (pin-name proto-pin)))))

(defmethod dup-pin (proto-self proto-map cloned-self cloned-map (proto-pin output-pin))
  (let ((proto-part (pin-parent proto-pin)))
    (let ((cloned-part (e/part::map-part proto-self proto-map cloned-self cloned-map (pin-parent proto-pin))))
      (e/part::get-output-pin cloned-part (pin-name proto-pin)))))

(defmethod input-p ((self pin))
  (eq 'input-pin (type-of self)))

(defmethod output-p ((self pin))
  (eq 'output-pin (type-of self)))

(defun new-pin (&key (pin-name "") (direction :in) pin-parent) ;; parent is unbound by default - always an error if parent is not bound (later)
  (make-instance
   (if (eq :input direction)
       'input-pin
     (if (eq :output direction)
         'output-pin
       (error (format nil "new-pin: pin direction must be specified as :input or :output, but ~S was given" direction))))
   :pin-name pin-name
   :pin-parent pin-parent))

(defun existing-pin (&key (pin-name "") (direction :in) pin-parent)
  (if (eq :input direction)
      (e/part::get-input-pin pin-parent pin-name)
    (if (eq :output direction)
        (e/part::get-output-pin pin-parent pin-name)
      (error (format nil "existing-pin: pin direction must be specified as :input or :output, but ~S was given" direction)))))

(defmethod pin-equal ((self pin) (other pin))
  (or (eq self other)
      (and
       (or (and (symbolp (pin-name self)) (equal (pin-name self) (pin-name other)))
           (and (stringp (pin-name self)) (string= (pin-name self) (pin-name other))))
       (eq (type-of self) (type-of other))
       (eq (pin-parent self) (pin-parent other)))))

(defmethod receive-event ((self input-pin) (e e/event:event))
  (let ((part (pin-parent self)))
    (push e (e/part::input-queue part))))

(defmethod receive-event ((self output-pin) (e e/event:event))
  (let ((part (pin-parent self)))
    (push e (e/part::output-queue part))))

(defmethod ensure-sanity (schem (self pin))
  (e/schematic::ensure-sanity schem (pin-parent self)))

(defmethod get-part ((self pin))
  (pin-parent self))

(defmethod get-sym ((self pin))
  (pin-name self))
