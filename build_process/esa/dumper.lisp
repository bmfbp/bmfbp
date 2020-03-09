(in-package :arrowgrams/compiler)

(defclass dumper (e/part:part) ())

(defparameter *dump-state* nil)

(defmethod e/part:first-time ((self dumper))
  (setf *dump-state* :idle))

(defmethod e/part:react ((self dumper) (e e/event:event))
  ;(format *standard-output* "~&dump ~S   ~S ~S~%" *dump-state* (@pin self e) (@data self e))
  (let ((tok (@data self e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) 
	     (@send self :pull id) #+nil(format *standard-output* "~&dump: pull ~S~%" id))
           (debug-tok (out-pin msg tok)
             (if (token-pulled-p tok)
                 (@send self out-pin (format nil "~&~a:~a pos:~a c:~a pulled-p:~a"
                                             msg
                                             (token-kind tok)
                                             (token-position tok)
                                             (if (member (token-kind tok) no-print) 
						 "." 
						 (token-text tok))
                                             (token-pulled-p tok)))
               (@send self out-pin (format nil "~&~a:~a pos:~a c:~a"
                                           msg
                                           (token-kind tok)
                                           (token-position tok)
                                           (if (member (token-kind tok) no-print) 
					       "." 
					       (token-text tok)))))))
      (ecase *dump-state*
        (:idle
         (ecase (@pin self e)
           (:start
            (pull :dump1)
            (setf *dump-state* :dumping))))
        
        (:dumping
         (ecase (@pin self e)
           (:in
            (debug-tok :out "" tok)
            (if (eq :EOF (token-text tok))
                (setf *dump-state* :done)
              (unless (token-pulled-p tok)
                (pull :dump2))))))
        
        (:done
         (debug-tok :error (format nil "dump done, but got ") tok))))))

(defmethod e/part:busy-p ((self dumper))
  (call-next-method))
