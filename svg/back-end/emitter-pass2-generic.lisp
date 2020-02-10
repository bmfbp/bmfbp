(in-package :arrowgrams/compiler/back-end)

(defclass emitter-pass2-generic (e/part:part) ())
(defmethod e/part:busy-p ((self emitter-pass2-generic)) (call-next-method))
(defparameter *emitter-pass2-generic-state* nil)

(defmethod e/part:first-time ((self emitter-pass2-generic))
  (setf *emitter-pass2-generic-state* :idle)
  (call-next-method))

(defmethod e/part:react ((self emitter-pass2-generic) (e e/event:event))
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
              (let ((p (make-instance 'parser :token-stream tokens :name "emitter pass2 generic")))
                (debug-sl nil)
                (debug-accept t)
                (schematic-emitter-pass2-generic p)
                (debug-accept nil)
                (debug-sl nil)
                (send! self :out (get-output p))
                (setf *emitter-pass2-generic-state* :done))))))
        
        (:done
         (send! self :error (format nil "generic emitter pass2 done, but received input~%"))))))
  (call-next-method))
