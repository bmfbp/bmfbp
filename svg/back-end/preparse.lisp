(in-package :arrowgrams/compiler)

(defclass preparse (compiler-part)
  ((stream :accessor stream)))

(defmethod e/part:busy-p ((self preparse)) (call-next-method))

(defmethod e/part:first-time ((self preparse))
  (setf (token-stream self) nil)
  (call-next-method))

(defmethod e/part:react ((self preparse) (e e/event:event))
  ;(format *standard-output* "~&preparse ~S   ~S ~S~%" *preparse-state* (e/event::sym e) (e/event:data e))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (@send self :request id) #+nil(format *standard-output* "~&preparse: pull ~S~%" id))
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
           (:start
            (pull :preparse1)
            (setf (state self) :slurping))))
        
        (:slurping
         (ecase (e/event::sym e)
           (:token
            (if (eq :EOF (token-text tok))
                (progn
                  (@send self :out (reverse (token-stream self)))
                  (e/part:first-time self))
              (progn
                (push tok (token-stream self))
                (unless (token-pulled-p tok)
                  (pull :preparse2)))))))))))
