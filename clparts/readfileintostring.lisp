;;INPUTS
;; (:filename "string")  reads complete file into a Lisp string, then @sends it to pin :out
;;
;;OUTPUTS
;; (:out String)
;; (:fatal object)       some fatal error, "object" specifies error details
;;



(in-package :arrowgrams)

(defmethod readfileintostring ((self e/part:part) (e e/event:event))
  (let ((data (e/event:data e))
        (action (e/event::sym e)))

    (assert (eq action :filename))
    (assert (or (pathnamep data) (stringp data)))
    
    (let ((str (alexandria:read-file-into-string data)))
      (cl-event-passing-user::@send self :out str))))
