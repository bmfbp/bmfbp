;;INPUTS
;; (:peg-in "string")   string containing full PEG source to be parsed
;;
;;OUTPUTS
;; (:lisp-list-out String) ;; the parsed PEG file, as one lisp LIST object
;; (:fatal object)       some fatal error, "object" specifies error details
;;

(in-package :arrowgrams)

(cl-peg:into-package :arrowgrams)

(defmethod pegtolisp ((self e/part:part) (e e/event:event))
  (let ((data (e/event:data e))
        (action (e/event::sym e)))

    (assert (eq action :peg-in))
    (assert (stringp data))
    
    (let ((parsed (cl-peg:fullpeg data)))
      (cl-event-passing-user:@send self :lisp-list-out parsed))))