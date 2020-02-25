(in-package :arrowgrams/compiler)

(defclass json-emitter (compiler-part) ())
(defmethod e/part:busy-p ((self json-emitter)) (call-next-method))

(defmethod e/part:first-time ((self json-emitter))
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
      (ecase (state self)
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
                (e/part::first-time self))))))))))