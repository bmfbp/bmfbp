;;INPUTS
;; (:in object) @send object to :out
;;
;;OUTPUTs
;; :out   the lisp object
;; :fatal some fatal error message (NIY)

(in-package :cl-event-passing-user)

(defmethod cat ((self e/part:part) (e e/event:event))
  (let ((lisp-obj (e/event:data e))
        (action (e/event::sym e)))

    (e/util::logging (format nil "cat action=~S data=~S" action lisp-obj))

    (case action
      (:in (@send self :out (format nil "~S" lisp-obj)))
      (otherwise (@send self :fatal t)))))
