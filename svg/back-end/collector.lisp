(in-package :arrowgrams/compiler)

(defclass collector (e/part:part) ())
(defmethod e/part:busy-p ((self collector)) (call-next-method))
; (:code collector (:parse) (:out :error) #'e/part:react #'e/part:first-time)

(defparameter *collector-state* nil)

(defmethod e/part:first-time ((self collector))
  (setf *collector-state* :idle)
  (call-next-method))

(defmethod e/part:react ((self collector) (e e/event:event))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (@send self :request id))
           (debug-tok (out-pin msg tok)
             (if (token-pulled-p tok)
                 (@send self out-pin (format nil "~&~a:~a pos:~a c:~a pulled-p:~a"
                                             msg
                                             (token-kind tok)
                                             (token-position tok)
                                             (if (member (token-kind tok) no-print) "." (token-text tok))
                                             (token-pulled-p tok)))
               (@send self out-pin (format nil "~&~a:~a pos:~a c:~a"
                                           msg
                                           (token-kind tok)
                                           (token-position tok)
                                           (if (member (token-kind tok) no-print) "." (token-text tok)))))))
      (ecase *collector-state*
        (:idle
         (ecase (e/event::sym e)
           (:parse
            (let ((p (make-instance 'parser :owner self :token-stream (e/event::data e) :name "collector" )))
              (format *standard-output* "~&collector~%")
              (debug-accept t)
              (ir-collector p 0)
              (let ((schem (top-schematic p)))
                (unparse-schematic p schem)
                (@send self :out (uget-unparsed-token-stream p))
                (setf *collector-state* :done))))))
        
        (:done
         (debug-tok :error (format nil "generic parser done, but got ") tok))))
    (call-next-method)))
