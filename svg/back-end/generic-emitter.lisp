(in-package :arrowgrams/compiler/back-end)

(defparameter *emitter-state* nil)

(defmethod generic-emitter-first-time ((self e/part:part))
  (setf *emitter-state* :idle)
  )

(defmethod generic-emitter-react ((self e/part:part) (e e/event:event))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (send! self :request id) #+nil(format *standard-output* "~&generic emitter: pull ~S~%" id))
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
      (ecase *emitter-state*
        (:idle
         (ecase (e/event::sym e)
           (:parse
            (let ((p (make-instance 'arrowgrams/compiler/back-end/generic::parser :owner self :token-stream (e/event::data e))))
              (arrowgrams/compiler/back-end/generic::ir p)
              (send! self :out (get-output p))
              (setf *emitter-state* :done)))))
        
        (:done
         (debug-tok :error (format nil "generic parser done, but got ") tok))))))
