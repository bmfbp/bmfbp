(in-package :arrowgrams/compiler/back-end)

; (:code eol (:token) (:request :out :error) #'eol-react #'eol-first-time)

(defparameter *eol-state* :idle)

(defmethod eol-first-time ((self e/part:part))
  (setf *eol-state* :idle)
  )

(defmethod eol-react ((self e/part:part) (e e/event:event))
  (flet ((new-newline (pos) (make-token :kind :newline :text #\Space :position pos))
         (forward-token () (send-event! self :out e)))
    (ecase *eol-state*
      (:idle
       (ecase (e/event::sym e)
         (:token
          (let ((tok (e/event:data e)))
            (cond ((eq :character (token-kind tok))
                   (let ((c (token-text tok)))
                     (case c
                       (#\Newline (send! self :out (new-newline (token-position tok))))
                       (otherwise (forward-token)))))
                  (t (forward-token))))))))))
