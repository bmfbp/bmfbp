(in-package :arrowgrams/compiler/back-end)

(defparameter *dumper-state* nil)

(defmethod dumper-first-time ((self e/part:part))
  (setf *dumper-state* :idle)
  )

(defmethod dumper-react ((self e/part:part) (e e/event:event))
  ;(format *standard-output* "~&dumper ~S   ~S ~S~%" *dumper-state* (e/event::sym e) (e/event:data e))
  (let ((tok (e/event::data e))
        (no-print '(:ws :newline :eof)))
    (ecase *dumper-state*
      (:idle
       (ecase (e/event::sym e)
         (:start
          (send! self :request t)
          (setf *dumper-state* :dumping))))

      (:dumping
       (ecase (e/event::sym e)
         (:in
          (send! self :out (format nil "~a pos:~a c:~a" (token-kind tok) (token-position tok)
                                   (if (member (token-kind tok) no-print) "." (token-text tok))))
          (if (eq :EOF (token-text tok))
              (setf *dumper-state* :done)
            (send! self :request t)))))
      
      (:done
       (send! self :error (format nil "dumper got an event, when dumper thinks it is done"))
       (send! self :out (format nil "~a pos:~a c:~a" (token-kind tok) (token-position tok)
                                (if (member (token-kind tok) no-print) "." (token-text tok))))))))
