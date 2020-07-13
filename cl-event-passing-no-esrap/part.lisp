(in-package :e/part)

(defclass part ()
  ((input-queue :accessor input-queue :initform nil) ;; a list of incoming Events
   (output-queue :accessor output-queue :initform nil) ;; a list of outgoing Events
   (busy-flag :accessor busy-flag :initform nil)
   (namespace-input-pins :accessor namespace-input-pins :initform nil) ;; a list of pin objects
   (namespace-output-pins :accessor namespace-output-pins :initform nil) ;; a list of pin objects
   (input-handler :accessor input-handler :initform nil :initarg :input-handler) ;; nil or a function
   (first-time-handler :accessor first-time-handler :initform nil) ;; nil or a function
   (parent-schem :accessor parent-schem :initform nil :initarg :parent-schem)
   (debug-name :accessor debug-name :initarg :debug-name :initform "") ;; for debug
   ;(current-input-event :accessor current-input-event :initform nil) ;; we might keep the latest event and form a call-back trace (a tree, not a stack)
   ))

(defclass code (part) ())

(defclass schematic (part)
  ((sources :accessor sources :initform nil) ;; a list of Sources (which contain a list of Wires which contain a list of Receivers)
   (internal-parts :accessor internal-parts :initform nil))) ; a list of Parts

(defgeneric first-time (part))
(defgeneric react (part event))

;; default implementations
(defmethod first-time ((self part))
  )

(defmethod state ((self part))
  nil)

(defmethod react ((self part) (e e/event:event))
  (declare (ignore self e))
  (format *error-output* "~&part ~s using default react method (nothing)~%" self)
  #+nil(assert nil)) ;; if you get this assertion, it probably means that you haven't defined e/part:react

(defmethod print-object ((obj code) out)
  (format out "<code[~a]>" (debug-name obj)))

(defmethod print-object ((obj schematic) out)
  (format out "<schematic[~a]>" (debug-name obj)))

(defmethod list-parts ((self (eql nil)))
  nil)

(defmethod list-parts ((self code))
  (list self))

(defmethod list-parts ((self schematic))
  (let ((lists (mapcar #'list-parts (internal-parts self))))
    (cons self (apply #'append lists))))

(defun clone-part (self proto)
  (setf (input-queue self) nil)
  (setf (output-queue self) nil)
  (setf (busy-flag self) nil)
  (setf (first-time-handler self) (first-time-handler proto))
  (setf (input-handler self) (input-handler proto))
  (setf  (debug-name self) (format nil "cloned ~a" (debug-name proto)))
  ; (setf parent-schem ... fixed up later
  (setf (namespace-input-pins self) (mapcar #'(lambda (pin)
                                                (e/pin::clone-with-part self pin))
                                            (namespace-input-pins proto)))
  (setf (namespace-output-pins self) (mapcar #'(lambda (pin)
                                                 (e/pin::clone-with-part self pin))
                                             (namespace-output-pins proto)))
  self)
 
(defmethod clone ((proto code))
  (let ((new (make-instance (type-of proto))))
    (let ((cloned (clone-part new proto)))
      cloned)))

(defmethod clone ((proto schematic))
  (let ((new (make-instance 'schematic)))
    (let ((cloned (clone-part new proto)))
      (setf (internal-parts cloned) (mapcar #'(lambda (p)
                                             (let ((new-part (clone p)))
                                               (setf (parent-schem new-part) cloned)
                                               new-part))
                                         (internal-parts proto)))
      ;; sources must be cloned after internal-parts has been cloned, sources and wires refer to self or to internal-parts
      ;; cloned.internal-parts maps 1:1 with proto.internal-parts
      (let ((proto-sources (internal-parts proto))
            (cloned-sources (internal-parts cloned)))
        (setf (sources cloned) (mapcar #'(lambda (s)
                                           (e/source::clone-with-mapping proto proto-sources cloned cloned-sources s))
                                       (sources proto)))
        cloned))))
  
(defmethod make-in-pins ((pin-parent part) lis)
  (flet ((symbol-or-string-or-integer-p (s)
           (or
            (symbolp s)
            (stringp s)))
         (already-an-input-pin-p (s)
           (and
            (eq 'e/pin:input-pin (type-of s))
            (e/pin::input-p s))))
    (mapcar #'(lambda (s)
                (if (symbol-or-string-or-integer-p s)
                    (e/pin::new-pin :pin-name s :direction :input :pin-parent pin-parent)
                  (if (already-an-input-pin-p s)
                      s
                    (error (format nil "input pin given as ~S but must be a symbol, string, integer or an input pin" s)))))
            lis)))

(defmethod make-out-pins ((pin-parent part) lis)
  (flet ((symbol-or-string-or-integer-p (s)
           (or
            (symbolp s)
            (stringp s)
            (numberp s)))
         (already-an-output-pin-p (s)
           (and (eq 'e/pin:output-pin (type-of s))
                (e/pin::output-p s))))
    (mapcar #'(lambda (s)
                (if (symbol-or-string-or-integer-p s)
                    (e/pin::new-pin :pin-name s :direction :output :pin-parent pin-parent)
                  (if (already-an-output-pin-p s)
                      s
                    (error (format nil "output pin given as ~S but must be a symbol, string, integer or an output pin" s)))))
            lis)))

(defun new-code (&key (class nil) (name "") (input-pins nil) (output-pins nil))
  (let ((self (if (null class)
                  (make-instance 'code :debug-name name)
                (make-instance class :debug-name name))))
    (let ((inpins (make-in-pins self input-pins))
	  (opins  (make-out-pins self output-pins)))
    (setf (e/part:namespace-input-pins self) inpins)
    (setf (e/part:namespace-output-pins self) opins)
    self)))

(defun reuse-part (proto &key (name ""))
  (let ((cloned (clone proto)))
    (let ((parts-list (e/part::list-parts cloned)))
      (mapc #'e/dispatch::memo-part parts-list))
    cloned))
  

(defmacro with-atomic-action (&body body)
  ;; basically a no-op in this, CALL-RETURN (non-asynch) version of the code
  ;; this matters only when running in a true interrupting environment (e.g. bare hardware, no O/S)
  `(progn ,@body))


(defgeneric ready-p (self))

(defmethod ready-p ((self e/part:code))
  (with-atomic-action
    (not (null (input-queue self)))))

(defmethod ready-p ((self e/part:schematic))
  (with-atomic-action
    (and (not (null (input-queue self)))
         (not (busy-p self)))))

(defgeneric busy-p (self))

(defmethod busy-p ((self code))
  (busy-flag self))
  
(defmethod busy-p ((self schematic))
  (with-atomic-action
    (or (e/part:busy-flag self) ;; never practically true in this implementation (based on CALL-RETURN instead of true interrupts)
        (some #'has-input-queue-p (internal-parts self))
        (some #'has-output-queue-p (internal-parts self))
        (some #'busy-p (internal-parts self)))))

(defgeneric busy-siblings-p (self))

(defmethod busy-siblings-p ((child e/part:part))
  (let ((parent (parent-schem child)))
    (or (null parent)
        (not (busy-p parent)))))
  
(defmethod has-input-queue-p ((self part))
  (not (null (input-queue self))))

(defmethod has-output-queue-p ((self part))
  (not (null (output-queue self))))

(defun find-name-in-namespace (namespace sym)
  (mapc #'(lambda (pin)
	    (when (if (symbolp sym)
                      (eq sym (e/pin:pin-name pin))
                    (if (numberp sym)
                        (= sym (e/pin:pin-name pin))
                      (string= sym (e/pin:pin-name pin))))
              (return-from find-name-in-namespace pin)))
            namespace)
  nil)

(defun must-find-name-in-namespace (namespace sym self pin-direction)
  (let ((pin (find-name-in-namespace namespace sym)))
    (unless pin
      (error (format nil "Name ~S not found in ~a namespace of ~s ~S" sym pin-direction self namespace)))
    pin))

(defun ensure-congruent-in-namespace (self namespace pin-list)
  (mapc #'(lambda (pin-sym)
            (unless (find-name-in-namespace namespace pin-sym)
              (error (format nil "pin ~S not found in ~S of part ~S" pin-sym namespace (debug-name self)))))
        pin-list))

(defmethod get-input-pin ((self part) pin-sym)
  (must-find-name-in-namespace (namespace-input-pins self) pin-sym self 'input))

(defmethod get-output-pin ((self part) pin-sym)
  (must-find-name-in-namespace (namespace-output-pins self) pin-sym self 'output))

(defmethod ensure-valid-input-pin ((self part) (pin e/pin:pin))
  (get-input-pin self (e/pin::get-sym pin)))

(defmethod ensure-valid-input-pin ((self part) (pin-sym symbol))
  (get-input-pin self pin-sym))

(defmethod ensure-valid-input-pin ((self part) (e e/event:event))
  (let ((sym (e/event::sym e)))
    (get-input-pin self sym)))

(defmethod ensure-valid-output-pin ((self part) (pin e/pin:pin))
  (get-output-pin self (e/pin::get-sym pin)))

(defmethod ensure-valid-output-pin ((self part) (pin-sym symbol))
  (get-output-pin self pin-sym))

;; part api

(defmethod exec1 ((self part))
  ;; execute exactly one input event to completion, then RETURN
  (let ((event (dequeue-input self)))
    (setf (busy-flag self) t)
    (e/util::logging self "exec1")
    (e/util::log-input self event)
    (e/event:display-event self event "input ")
    (react self event)
    (e/event:display-output-events self event (output-queue self))
    (e/util::log-outputs self)
    (setf (busy-flag self) nil)))

(defmethod output-queue-as-list ((self part))
  ;; return output queue as a list of output events,
  (let ((list (output-queue self)))
    (reverse list))) ;; ensure output events are in the order that was sent

(defmethod output-queue-as-list-and-delete ((self part))
  ;; return output queue as a list of output events,
  ;; and null out the output queue
  (let ((list (output-queue self)))
    (setf (output-queue self) nil)
    (reverse list))) ;; ensure output events are in the order that was sent

(defmethod name ((p part))
  (if (string= "" (debug-name p))
      p
    (debug-name p)))

(defmethod input-pins ((self part))
  (namespace-input-pins self))

(defmethod output-pins ((self part))
  (namespace-output-pins self))

(defmethod ensure-congruent-input-pins ((self part) input-pins)
  (ensure-congruent-in-namespace self (namespace-input-pins self) input-pins))

(defmethod ensure-congruent-output-pins ((self part) output-pins)
  (ensure-congruent-in-namespace self (namespace-output-pins self) output-pins))

(defmethod has-parent-p ((self part))
  (not (null (parent-schem self))))

(defmethod has-output-p ((self part))
  (not (null (output-queue self))))

(defmethod map-part (proto-self proto-map cloned-self cloned-map (proto-part part))
  ;; find cloned part corresponding to proto-part, given a list of proto parts and a corresponding list
  ;; of cloned parts
  ;; edge case: if proto-part == proto-self then return cloned-self
  (if (eq proto-part proto-self)
      cloned-self
    (progn
      (assert (= (length proto-map) (length cloned-map)))
      (let ((index (position proto-part proto-map)))
        (assert index) ;; can't happen - we must be able to find the proto-part in the proto-map
        (nth index cloned-map)))))

(defmethod dequeue-input ((self part))
  (let ((e (first (last (input-queue self)))))
    (setf (input-queue self) (butlast (input-queue self)))
    e))

