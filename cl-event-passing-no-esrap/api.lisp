(in-package :cl-event-passing-user)

(defparameter *top-level-part* nil)

;; internal method (not API)
(defmethod is-top-level-p ((part e/part:part))
  (assert *top-level-part*)
  (eq part *top-level-part*))


;; API...

(defun @new-schematic (&key (name "") (input-pins nil) (output-pins nil) (first-time-handler nil))
  (let ((schem (e/schematic::new-schematic :name name :input-pins input-pins :output-pins output-pins
                                           :first-time-handler first-time-handler)))
    schem))

(defun @new-code (&key (kind nil) (name "") (input-pins nil) (output-pins nil) (input-handler nil) (first-time-handler nil))
  (let ((part (e/part::new-code :class kind :name name :class name)))
    (setf (e/part:namespace-input-pins part) (e/part::make-in-pins part input-pins))
    (setf (e/part:namespace-output-pins part) (e/part::make-out-pins part output-pins))
    #+nil(setf (e/part:input-handler part) input-handler)
    #+nil(setf (e/part:first-time-handler part) first-time-handler)
    part))

(defun @reuse-part (proto &key (name "") (input-pins nil) (output-pins nil))
  (let ((cloned-part (e/part::reuse-part proto :name name)))
    (e/part::ensure-congruent-input-pins cloned-part input-pins)
    (e/part::ensure-congruent-output-pins cloned-part output-pins)
    cloned-part))

(defun @new-wire (&key (name ""))
  (e/wire::new-wire :name name))

(defun @new-event (&key (event-pin nil) (data nil) (tag nil) (detail :tag))
  (e/event::new-event :event-pin event-pin :data data :tag tag :detail detail))

(defun @initialize ()
  (e/util::reset)
  (e/dispatch::reset))

(defmethod @top-level-schematic ((schem e/part:schematic))
  (setf *top-level-part* schem)  ;; for debugging only
  (e/dispatch::memo-part schem)) ;; always needed

(defmethod @set-first-time-handler ((part e/part:part) fn)
  (setf (e/part::first-time-handler part) fn))

(defmethod @set-input-handler ((part e/part:part) fn)
  (setf (e/part::input-handler part) fn))

(defmethod @add-receiver-to-wire ((wire e/wire:wire) (pin e/pin:pin))
  (let ((rcv (e/receiver::new-receiver :pin pin)))
    (e/wire::ensure-receiver-not-already-on-wire wire rcv)
    (e/wire::add-receiver wire rcv)))

(defmethod @add-source-to-schematic ((schem e/part:schematic) (pin e/pin:pin) (wire e/wire:wire))
  (let ((s (e/source::new-source :pin pin :wire wire)))
    (e/schematic::ensure-source-not-already-present schem s)
    (e/schematic::add-source schem s)))

(defmethod @add-part-to-schematic ((schem e/part:schematic) (part e/part:part))
  (e/schematic::ensure-part-not-already-present schem part)
  (e/schematic::add-part schem part)
  (e/dispatch::memo-part part))

(defun find-any-symbol-helper (body)
  (cond ((null body) nil)
        ((symbolp body)
         (if (or (eq (find-package "COMMON-LISP") (symbol-package body))
                 (eq (find-package "CL-EVENT-PASSING-USER") (symbol-package body))
                 (eq (find-package "KEYWORD") (symbol-package body))
                 (eq (find-package "CL-EVENT-PASSING-PART") (symbol-package body)))
             nil
           body))
        ((atom body) nil)
        ((listp body)
         (dolist (i body)
           (let ((sym (find-any-symbol-helper i)))
             (when sym
               (return-from find-any-symbol-helper sym)))))
        (t (assert nil)))) ;; can't happen

(defun find-any-symbol (body)
  (let ((item (find-any-symbol-helper body)))
;(format *standard-output* "~&~%find-any-symbol = ~s~%~%" item)
    (if item
        item
      'cl-event-passing-user::find-any-symbol-helper)))

(defmacro @with-dispatch (&body body)
  (let ((user-package (find-package (symbol-package (find-any-symbol body)))))
    (let ((inj (intern "@INJECT" user-package)))
      `(flet ((,inj (part pin data &key (tag nil) (detail :tag))
                (unless (eq 'e/pin:input-pin (type-of pin))
                  (error "pin must be specified with get-pin (~s)" pin))
                (let ((e (e/event::new-event :event-pin pin :data data :tag tag :detail detail)))
                  (e/util:logging e)
                  (push e (e/part:input-queue part)))))
         (e/dispatch::run-first-times)
         ,@body
         (e/dispatch::run))))) ;; this might create huge input queues ; maybe we want @with-dispatch-loop where the body contains no loops


(defmethod @send ((self e/part:part) (sym SYMBOL) data &key (tag nil) (detail :tag))
  (@send self (e/part::get-output-pin self sym) data :tag tag :detail detail))

(defmethod @send ((self e/part:part) (pin e/pin:pin) data &key (tag nil) (detail :tag))
  (let ((e (e/event:new-event :event-pin pin :data data :tag tag :detail detail)))
    (e/util:logging e)
    (push e (e/part:output-queue self))))

(defun @start-dispatcher ()
  (e/dispatch::start-dispatcher))

(defun @enable-tracing (stream)
  (e/util::enable-tracing stream))

(defun @history ()
  (e/util::get-logging))

(defun @enable-logging (&optional (n 2))
  (e/util::enable-logging n))

(defmethod @pin ((self e/part:part) (e e/event:event))
  ;; return symbol for input pin of e
  (declare (ignore self))
  (e/part::ensure-valid-input-pin self e)
  (e/event::sym e))

(defmethod @data ((self e/part:part) (e e/event:event))
  ;; return data from event
  (declare (ignore self))
  (e/event::data e))

(defmethod @get-input-pin ((self e/part:part) name)
  (e/part::get-input-pin self name))

(defmethod @get-output-pin ((self e/part:part) name)
  (e/part::get-output-pin self name))
