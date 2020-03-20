(in-package :arrowgrams/compiler)

(defclass json1-emitter (compiler-part) 
  ())

(defmethod e/part:busy-p ((self json1-emitter)) (call-next-method))

(defmethod e/part:first-time ((self json1-emitter))
  (call-next-method))

(defmethod e/part:react ((self json1-emitter) (e e/event:event))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (@send self :request id) #+nil(format *standard-output* "~&json1 emitter: pull ~S~%" id))
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
      (ecase (state self)
        (:idle
         (ecase (e/event::sym e)
           (:parse
            (let ((p (make-instance 'parser :owner self :token-stream (e/event::data e) :name "json1 emitter")))
              (debug-accept t)
              (ir-json1 p)
              (@send self :out (get-output p))
              (e/part::first-time self)))))))))