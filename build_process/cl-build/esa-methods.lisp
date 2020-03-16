(in-package :arrowgrams/build)

(defmethod install-input-pin ((self kind) name)
  (push name (input-pins self)))

(defmethod install-output-pin ((self kind) name)
  (push name (output-pins self)))

(defmethod install-initially-function ((self kind) fn)
  (assert nil)) ;; should be explicitly defined in each class

(defmethod install-react-function ((self kind) fn)
  (assert nil)) ;; should be explicitly defined in each class

(defmethod install-wire ((self kind) (w wire))
  (push w (wires self)))

(defmethod install-part ((self kind) name kind)
  (let ((p (make-instance 'part-definition)))
    (setf (part-name p) name)
    (setf (part-kind p) kind)
    (push p (parts self))))

(defmethod children ((self kind))
  (parts self))

(defmethod ensure-part-not-declared ((self kind) name)
  (dolist (part (parts self))
    (when (string= name (part-name part))
      (error (format nil "part ~a already declared in ~s" name self))))
   T)

(defmethod ensure-valid-input-pin ((self kind) name)
  (dolist (pin-name (input-pins self))
    (when (string= pin-name name)
      (return-from ensure-valid-input-pin T)))
  (error (format nil "pin ~a is not an input pin of ~s" name self)))

(defmethod ensure-valid-output-pin ((self kind) name)
  (dolist (pin-name (output-pins self))
    (when (string= pin-name name)
      (return-from ensure-valid-output-pin T)))
  (error (format nil "pin /~a/ is not an output pin of ~s" name self)))

(defmethod ensure-input-pin-not-declared ((self kind) name)
  (dolist (pin-name (input-pins self))
    (when (string= pin-name name)
      (error (format nil "pin /~a/ is already declared as an input pin of ~s" name self))))
  T)

(defmethod ensure-output-pin-not-declared ((self kind) name)
  (dolist (pin-name (output-pins self))
    (when (string= pin-name name)
      (error (format nil "pin /~a/ is already declared as an output pin of ~s" name self))))
  T)

(defmethod refers-to-self? ((self source))
  (string= "self" (part-name self)))

(defmethod refers-to-self? ((self destination))
  (string= "self" (part-name self)))


;  wires

(defmethod set-index ((self wire) i)
  (setf (index self) i))

(defmethod install-source ((self wire) part-name pin-name)
  (let ((s (make-instance 'source)))
    (setf (part-name s) part-name)
    (setf (pin-name s) pin-name)
    (push s (sources self))))
          
(defmethod install-destination ((self wire) part-name pin-name)
  (let ((d (make-instance 'destination)))
    (setf (part-name d) part-name)
    (setf (pin-name d) pin-name)
    (push d (destinations self))))


;; nodes

(defmethod clear-input-queue ((self node))
  (setf (input-queue self) nil))

(defmethod clear-output-queue ((self node))
  (setf (output-queue self) nil))

;(defmethod children ((self node)) ;; already defined in declaration of accessor
  
; (defmethod intially ((self node))  needs to be explicitly declared in each class instance

(defmethod send ((self node) (e event))
  (setf (output-queue self) (append (output-queue self) (list e))))

(defmethod output-events ((self node))
  (output-queue self))

(defmethod dequeue-input ((self node))
  (pop (input-queue self)))

(defmethod input-queue? ((self node))
  (not (null (input-queue self))))

(defmethod enqueue-input ((self node) (e event))
  (setf (input-queue self) (append (input-queue self) (list e))))

(defmethod enqueue-output ((self node) (e event))
  (setf (output-queue self) (append (output-queue self) (list e))))

(defmethod find-wire-for-source ((self node) part-name pin-name)
  (dolist (w (wires self))
    (dolist (s (sources w))
      (when (and (string= part-name (part-name s))
                 (string= pin-name  (pin-name s)))
        (return-from find-wire-for-source w))))
  (assert nil)) ;; source not found - can't happen

(defmethod find-child ((self kind) name)
  (dolist (p (parts self))
(format *standard-output* "~&find-child ~s ~s~%" (part-name p) name)
    (when (string= name (part-name p))
      (return-from find-child p)))
  (assert nil)) ;; no part with given name - can't happen
