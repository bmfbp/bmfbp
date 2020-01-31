(in-package :arrowgrams/compiler/back-end)

(defparameter *emitter-pass2-generic-state* nil)

(defmethod emitter-pass2-generic-first-time ((self e/part:part))
  (setf *emitter-pass2-generic-state* :idle)
  )

(defmethod emitter-pass2-generic-react ((self e/part:part) (e e/event:event))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (send! self :request id))
           (debug-tok (out-pin msg tok)
             (if (token-pulled-p tok)
                 (format nil "~&~a:~a pos:~a c:~a pulled-p:~a"
                         msg
                         (token-kind tok)
                         (token-position tok)
                         (if (member (token-kind tok) no-print) "." (token-text tok))
                         (token-pulled-p tok)))
             (format nil "~&~a:~a pos:~a c:~a"
                     msg
                     (token-kind tok)
                     (token-position tok)
                     (if (member (token-kind tok) no-print) "." (token-text tok)))))
      (ecase *emitter-pass2-generic-state*
        (:idle
         (ecase (e/event::sym e)
           
           (:in
            (let ((tokens (e/event:data e)))
              (let ((p (make-instance 'parser :token-stream tokens)))
                (debug-sl t)
                (schematic-emitter-pass2-generic p)
                (debug-sl nil)
                (send! self :out (get-output p))
                (setf *emitter-pass2-generic-state* :done))))))
        
        (:done
         (send! self :error (format nil "generic emitter pass2 done, but received input~%")))))))

