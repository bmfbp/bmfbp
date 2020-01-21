(in-package :arrowgrams/compiler/back-end)

(defparameter *dumper-state* nil)

(defmethod dumper-first-time ((self e/part:part))
  (setf *dumper-state* :idle)
  )

(defmethod dumper-react ((self e/part:part) (e e/event:event))
  (format *standard-output* "~&dumper ~S   ~S ~S~%" *dumper-state* (e/event::sym e) (e/event:data e))
  (flet ((pull (id) (send! self :request id)))
    (let ((tok (e/event::data e))
          (no-print '(:ws :newline :eof)))
      (ecase *dumper-state*
        (:idle
         (ecase (e/event::sym e)
           (:start
            (pull :dumper1)
            (setf *dumper-state* :dumping))))

        (:dumping
         (ecase (e/event::sym e)
           (:in
            (send! self :out (format nil "~a pos:~a c:~a" (token-kind tok) (token-position tok)
                                     (if (member (token-kind tok) no-print) "." (token-text tok))))
            (if (eq :EOF (token-text tok))
                (setf *dumper-state* :done)
              (if (eq :character (token-text tok))
                  (pull :dumper2)
                (if (> (length (token-text tok)) 1)
                    (pull :dumper3)))))))
      
        (:done
         (send! self :error (format nil "dumper done, but got ~a pos:~a c:~a" (token-kind tok) (token-position tok)
                                    (if (member (token-kind tok) no-print) "." (token-text tok)))))))))
