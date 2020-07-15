;; inputs
;; - token
;; - eof

;; outputs
;; - request
;; - error


(defclass token-dumper (node) () )

(defmethod initially ((self token-dumper))
  (send self :request t))

(defmethod react ((self token-dumper) (e event))
  (ecase (pin (partpin e))
    (:token
     (format *standard-output* "token ~s~%" (data e)))
    (:eof
     (format *standard-output* "EOF~%"))
    (otherwise
     (send self :error "error in token dumper on event ~s" e))))


