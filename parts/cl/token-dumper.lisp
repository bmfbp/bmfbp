;; inputs
;; - token
;; - eof

;; outputs
;; - request
;; - error


(defclass token-dumper (node) () )

(defmethod initially ((self token-dumper))
  )

(defmethod react ((self token-dumper) (e event))
  (ecase (pin-name (partpin e))
    (:token
     (format *standard-output* "token ~s~%" (data e))
     (send-to-pin self "request" t))
    (:eof
     (format *standard-output* "EOF~%"))
    (otherwise
     (send-to-pin self "error" "error in token dumper on event ~s" e))))

(defmethod send-to-pin ((self token-dumper) pin-string data)
  (let ((e (make-instance 'event))
        (pp (make-instance 'part-pin)))
    (setf (part-name pp) (name-in-container self))
    (setf (pin-name pp) pin-string)
    (setf (partpin e) pp)
    (setf (data    e) data)
    (send self e)))


