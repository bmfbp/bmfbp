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
  (cond ((string= "token" (pin-name (partpin e)))
         (format *standard-output* "token ~s~%" (data e))
         (send-to-pin self "request" t))
        ((string= "eof" (pin-name (partpin e)))
         (format *standard-output* "EOF ~s~%" (data e)))
        (t
         (send-to-pin self "error" (format nil "error in token dumper on event ~s" e)))))

(defmethod send-to-pin ((self token-dumper) pin-string data)
  (let ((e (make-instance 'event))
        (pp (make-instance 'part-pin)))
    (setf (part-name pp) (name-in-container self))
    (setf (pin-name pp) pin-string)
    (setf (partpin e) pp)
    (setf (data    e) data)
    (send self e)))


