(in-package :arrowgrams/compiler)

(defclass dumper (compiler-part) ())

(defmethod e/part:first-time ((self dumper))
  (call-next-method))

(defmethod e/part:react ((self dumper) (e e/event:event))
  ;(format *standard-output* "~&dumper ~S   ~S ~S~%" *dumper-state* (e/event::sym e) (e/event:data e))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (flet ((pull (id) (@send self :request id) #+nil(format *standard-output* "~&dumper: pull ~S~%" id))
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
            (pull :dumper1)
            (setf (state self) :dumping))))
        
        (:dumping
         (ecase (e/event::sym e)
           (:in
            (debug-tok :out "" tok)
            (if (eq :EOF (token-text tok))
                (e/part:first-time self)
              (unless (token-pulled-p tok)
                (pull :dump2))))))))))

