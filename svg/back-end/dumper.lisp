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
        (send! self :request :next t))
       (:next
        (let ((tok (e/event::data e)))
          (let ((kind (token-kind tok))
                (c    (token-text tok)))
            (send! self :out :message (format nil "~S pos:~a c:~S" kind (token-position tok) c))
            (if (eq :EOF c)
                (setf *state* :done)
              (send! self :request :next t)))))))
    
    (:done
     (send! self :error :message (format nil "dumper got an event, when dumper thinks it is done")))))
