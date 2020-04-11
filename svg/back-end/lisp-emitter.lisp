(in-package :arrowgrams/compiler)

(defclass lisp-emitter (compiler-part) 
  ())

(defmethod e/part:busy-p ((self lisp-emitter)) (call-next-method))

(defmethod e/part:first-time ((self lisp-emitter))
  (call-next-method))

(defmethod e/part:react ((self lisp-emitter) (e e/event:event))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (@send self :request id) #+nil(format *standard-output* "~&lisp emitter: pull ~S~%" id))
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
            (let ((p (make-instance 'parser :owner self :token-stream (e/event::data e) :name "lisp emitter")))
              (debug-accept nil)
              (debug-accept nil)
              (ir-lisp p)
              (@send self :out (get-output p))
              (e/part::first-time self)))))))))
