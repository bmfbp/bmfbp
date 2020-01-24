(in-package :arrowgrams/compiler/back-end)

(defparameter *generic-json-parser-state* nil)

(defmethod generic-json-parser-first-time ((self e/part:part))
  (setf *generic-json-parser-state* :idle)
  )

(defmethod generic-json-parser-react ((self e/part:part) (e e/event:event))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (send! self :request id))
           (debug-tok (out-pin msg tok)
             (if (token-pulled-p tok)
                 (send! self out-pin (format nil "~&~a:~a pos:~a c:~a pulled-p:~a"
                                             msg
                                             (token-kind tok)
                                             (token-position tok)
                                             (if (member (token-kind tok) no-print) "." (token-text tok))
                                             (token-pulled-p tok)))
               (send! self out-pin (format nil "~&~a:~a pos:~a c:~a"
                                           msg
                                           (token-kind tok)
                                           (token-position tok)
                                           (if (member (token-kind tok) no-print) "." (token-text tok)))))))
      (ecase *generic-json-parser-state*
        (:idle
         (ecase (e/event::sym e)
           (:parse
            (let ((p (make-instance 'arrowgrams/compiler/back-end/json-collector::parser :owner self :token-stream (e/event::data e))))
              (arrowgrams/compiler/back-end/json-collector::ir p)
              (send! self :out (get-output p))
              (setf *generic-json-parser-state* :done)))))
        
        (:done
         (debug-tok :error (format nil "generic json parser done, but got ") tok))))))
