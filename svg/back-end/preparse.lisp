(in-package :arrowgrams/compiler/back-end)

(defclass preparse (e/part:part) ())
(defmethod e/part:busy-p ((self preparse)) (call-next-method))

(defparameter *preparse-state* nil)
(defparameter *preparse-token-stream* nil) ;; an ordered list of tokens

(defmethod e/part:first-time ((self preparse))
  (setf *preparse-state* :idle)
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
      (ecase *preparse-state*
        (:idle
         (ecase (e/event::sym e)
           (:start
            (pull :preparse1)
            (setf *preparse-state* :slurping))))
        
        (:slurping
         (ecase (e/event::sym e)
           (:token
            (if (eq :EOF (token-text tok))
                (progn
                  (@send self :out (reverse *preparse-token-stream*))
                  (setf *preparse-state* :done))
              (progn
                (push tok *preparse-token-stream*)
                (unless (token-pulled-p tok)
                  (pull :preparse2)))))))

        (:done
         (debug-tok :error (format nil "preparse done, but got ") tok)))))
  (call-next-method))
