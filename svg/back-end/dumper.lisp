(in-package :arrowgrams/compiler/back-end)

(defparameter *state* nil)

(defmethod dumper-first-time ((self e/part:part))
  (setf *state* :dumping)
  )

(defmethod dumper-react ((self e/part:part) (e e/event:event))
  (ecase *state*
    (:dumping
     (ecase (e/event::sym e)
       (:start
        (send! self :request t))
       (:in
        (let ((tok (e/event::data e)))
          (let ((kind (token-kind tok))
                (c    (token-text tok)))
            (send! self :out (format nil "~a pos:~a c:~a" kind (token-position tok) c))
            (if (eq :EOF c)
                (setf *state* :done)
              (send! self :request t)))))))
    
    (:done
     (send! self :error (format nil "dumper got an event, when dumper thinks it is done")))))
