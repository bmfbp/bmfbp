(in-package :arrowgrams/build)


;; for bootstrap - make names case insensitive - downcase everything

(defun esa-if-failed-to-return-true-false (msg)
  (error (format nil "esa-if - expr did not return :true or :false ~s" msg)))

(defun esa-expr-true (x)
  (cond ((eq :true x) t)
        ((eq :false x) nil)
        (t (error (format nil "~&esa expression returned /~s/, but expected :true or :false" x)))))
  


(defmethod install-input-pin ((self kind) name)
  (push (string-downcase name) (input-pins self)))

(defmethod install-output-pin ((self kind) name)
  (push (string-downcase name) (output-pins self)))

(defmethod install-initially-function ((self kind) fn)
  (assert nil)) ;; should be explicitly defined in each class

(defmethod install-react-function ((self kind) fn)
  (assert nil)) ;; should be explicitly defined in each class

(defmethod install-wire ((self kind) (w wire))
  (push w (wires self)))

(defmethod install-part ((self kind) name kind node-class)
  (let ((p (make-instance 'part-definition)))
    (setf (part-name p) (string-downcase name))
    (setf (part-kind p) kind)
    (push p (parts self))))

(defmethod kind-find-part ((self kind) name)
  (dolist (p (parts self))
    (when (string=-downcase name (part-name p))
      (return-from kind-find-part p)))
  (assert nil)) ;; no part with given name - can't happen

(defmethod ensure-part-not-declared ((self kind) name)
  (dolist (part (parts self))
    (when (string=-downcase name (part-name part))
      (error (format nil "part ~a already declared in ~s ~s" name (kind-name self) self))))
   T)

(defmethod ensure-valid-input-pin ((self kind) name)
  (dolist (pin-name (input-pins self))
    (when (string=-downcase pin-name name)
      (return-from ensure-valid-input-pin T)))
  (error (format nil "pin ~a is not an input pin of ~s ~s" name (kind-name self) self)))

(defmethod ensure-valid-output-pin ((self kind) name)
  (dolist (pin-name (output-pins self))
    (when (string=-downcase pin-name name)
      (return-from ensure-valid-output-pin T)))
  (error (format nil "pin /~a/ is not an output pin of ~s ~s" name (kind-name self) self)))

(defmethod ensure-input-pin-not-declared ((self kind) name)
  (when (slot-boundp self 'input-pins)
    (dolist (pin-name (input-pins self))
      (when (string=-downcase pin-name name)
	(error (format nil "pin /~a/ is already declared as an input pin of ~s ~s" name (kind-name self) self)))))
  T)

(defmethod ensure-output-pin-not-declared ((self kind) name)
  (dolist (pin-name (output-pins self))
    (when (string=-downcase pin-name name)
      (error (format nil "pin /~a/ is already declared as an output pin of ~s ~s" name (kind-name self) self))))
  T)

(defmethod refers-to-self? ((self source))
  (if (string=-downcase "self" (part-name self))
      :true
     :false))

(defmethod refers-to-self? ((self destination))
  (if (string=-downcase "self" (part-name self))
      :true
     :false))

(defmethod refers-to-self? ((self part-pin))
  (if (string=-downcase "self" (part-name self))
      :true
     :false))


;  wires

(defmethod set-index ((self wire) i)
  (setf (index self) i))

(defmethod install-source ((self wire) part-name pin-name)
  (let ((s (make-instance 'source)))
    (setf (part-name s) (string-downcase part-name))
    (setf (pin-name s) (string-downcase pin-name))
    (push s (sources self))))
          
(defmethod install-destination ((self wire) part-name pin-name)
  (let ((d (make-instance 'destination)))
    (setf (part-name d) (string-downcase part-name))
    (setf (pin-name d) (string-downcase pin-name))
    (push d (destinations self))))


;; nodes


(defmethod clear-input-queue ((self node))
  (setf (input-queue self) nil))

(defmethod clear-output-queue ((self node))
  (setf (output-queue self) nil))

; (defmethod instances ((self node)) ;; already defined in declaration of accessor
  
; (defmethod intially ((self node))  needs to be explicitly declared in each class instance

(defmethod initially ((self node))
  ;; graphs have no initially
  ;; leaves might have an initially
  ;; (call-next-method) ends up here - nothing to do
  (format *error-output* "~&initially on ~s ~s~%" (name-in-container self) self))

(defmethod display-output-events-to-console-and-delete ((self node))
  (dolist (e (get-output-events-and-delete self))
    (format *standard-output* "~s" (data e))))
    ;(format *standard-output* "~&~s outputs on pin ~s : ~s~%" (name-in-container self) (pin-name (partpin e)) (data e))))

(defmethod flagged-as-busy? ((self node))
  (if (busy-flag self)
      :true
     :false))

(defmethod children? ((self node))
  (if (not (null (children self)))
      :true
     :false))

(defmethod has-no-container? ((self node))
  (if (null (container self))
      :true
     :false))

(defmethod send ((self node) (e event))
  (setf (output-queue self) (append (output-queue self) (list e))))

(defmethod get-output-events-and-delete ((self node))
  (let ((out-event-list (output-queue self)))
    (setf (output-queue self) nil)
    out-event-list))

(defmethod dequeue-input ((self node))
  (pop (input-queue self)))

(defmethod input-queue? ((self node))
  (if (not (null (input-queue self)))
      :true
     :false))

(defmethod has-inputs-or-outputs? ((self node))
  (if (or (not (null (input-queue self)))
	  (not (null (output-queue self))))
      :true
     :false))

(defmethod install-child ((self node) name (child node))
  (let ((pinstance (make-instance 'named-part-instance)))
    (setf (instance-name pinstance) name)
    (setf (instance-node pinstance) child)
    (push pinstance (children self))))

(defmethod enqueue-input ((self node) (e event))
  (setf (input-queue self) (append (input-queue self) (list e))))

(defmethod enqueue-output ((self node) (e event))
  (setf (output-queue self) (append (output-queue self) (list e))))

(defmethod find-wire-for-self-source ((self kind) pinname)
  ;(format *standard-output* "~&find-wire-for-self-source A ~s wires.len=~s~%" (kind-name self) (length (wires self)))
  (dolist (w (wires self))
    ;(format *standard-output* "~&find-wire-for-self-source B ~s sources=~s~%" w (sources w))
    (dolist (s (sources w))
      ;(format *standard-output* "~&find-wire-for-self-source C ~s ~s~%" pinname (pin-name s))
      (when (string=-downcase pinname  (pin-name s)))
      (return-from find-wire-for-self-source w)))
  (assert nil)) ;; source not found - can't happen

(defmethod find-wire-for-source ((self kind) part-name pin-name)
  ;(format *standard-output* "~&find-wire-for-source ~s ~s in ~s ~s ~%" part-name pin-name (kind-field self) self)
  (dolist (w (wires self))
    (dolist (s (sources w))
      (when (and (or (string= "self" (part-name s))
                     (string=-downcase part-name (part-name s)))
                 (string=-downcase pin-name  (pin-name s)))
        (return-from find-wire-for-source w))))
  (make-instance 'wire)) ;;(assert nil)) ;; source not found - can't happen - NC!

(defmethod node-find-child ((self node) name)
  ;(format *standard-output* "~&node-find-child of ~s wants ~s~%" (name-in-container self) name)
  (dolist (p (children self))
    (when (string=-downcase name (instance-name p))
      (return-from node-find-child p)))
  (assert nil)) ;; no part with given name - can't happen

(defmethod ensure-kind-defined ((self part-definition))
  (unless (eq 'kind (type-of (part-kind self)))
    (error (format nil "kind for part ~a is not defined (check if manifest is correct)" (part-name self)))))


(defmethod memo-node ((self dispatcher) (n node))
  (push n (all-parts self)))

(defmethod set-top-node ((self dispatcher) (n node))
  (setf (top-node self) n))

(defmethod declare-finished ((self dispatcher))
  #+nil(format *standard-output* "~&~%Dispatcher Finished~%~%"))


(defun string=-downcase (a b)
  (string= (string-downcase a) (string-downcase b)))

(defmethod get-destination ((self event))
  (let ((d (make-instance 'destination)))
    (setf (part-name d) (part-name self))
    (setf (pin-name d) (pin-name self))))

(defmethod react ((self node) (e event))
  (run-composite-reaction self e))
