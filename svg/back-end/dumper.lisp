(in-package :arrowgrams/compiler/back-end)

(defparameter *state* nil)

(defmethod dumper-first-time ((self e/part:part))
  (setf *state* :dumping)
  )

(defmethod dumper-react ((self e/part:part) (e e/event:event))
  (let ((tok (e/event::data e)))
    (ecase *state*
      (:dumping
       (ecase (e/event::sym e)
         (:start
          (send! self :request t))
         (:in
          (send! self :out (format nil "~a pos:~a c:~a" (token-kind tok) (token-position tok) (if (eq :ws (token-kind tok)) "." (token-text tok))))
          (if (eq :EOF (token-text tok))
              (setf *state* :done)
            (send! self :request t)))))
      
      (:done
       (send! self :error (format nil "dumper got an event, when dumper thinks it is done"))
       (send! self :out (format nil "~a pos:~a c:~a" (token-kind tok) (token-position tok) (if (eq :ws (token-kind tok)) "." (token-text tok))))))))
