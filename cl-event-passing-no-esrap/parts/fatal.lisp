;;INPUTS
;; (:in object) print error object
;;
;;OUTPUTs

(in-package :cl-event-passing-user)

(defmethod fatal ((self e/part:part) (e e/event:event))
  (format *error-output* "~&FATAL error ~S~%" (e/event:data e)))
