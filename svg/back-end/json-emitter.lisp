(in-package :arrowgrams/compiler/back-end)

(defclass json-emitter (e/part:part) ())
(defmethod e/part:busy-p ((self json-emitter)) (call-next-method))
(defparameter *json-emitter-state* nil)

(defmethod e/part:first-time ((self json-emitter))
  (setf *json-emitter-state* :idle)
  (call-next-method))

(defmethod e/part:react ((self json-emitter) (e e/event:event))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (@send self :request id))
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
      (ecase *json-emitter-state*
        (:idle
         (ecase (e/event::sym e)
           
           (:in
            (let ((tokens (e/event:data e)))
              (let ((p (make-instance 'parser :token-stream tokens :name "json emitter")))
                (debug-sl nil)
                (debug-accept nil)
                (schematic-json-emitter p)
                (debug-accept nil)
                (debug-sl nil)
                (@send self :out (get-output p))
                (setf *json-emitter-state* :done))))))
        
        (:done
         (@send self :error (format nil "json emitter done, but received input~%"))))))
  (call-next-method))
