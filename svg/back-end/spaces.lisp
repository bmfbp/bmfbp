(in-package :arrowgrams/compiler/back-end)

; (:code spaces (:token) (:request :out :error) #'spaces-react #'spaces-first-time)

(defparameter *spaces-state* :idle)

(defmethod spaces-first-time ((self e/part:part))
  (setf *spaces-state* :idle)
  )

(defmethod spaces-react ((self e/part:part) (e e/event:event))
  (flet ((new-newline (pos) (make-token :kind :ws :text #\Space :position pos))
         (forward-token () (send-event! self :out e)))
    (ecase *spaces-state*
      (:idle
       (ecase (e/event::sym e)
         (:token
          (let ((tok (e/event:data e)))
            (cond ((eq :character (token-kind tok))
                   (let ((c (token-text tok)))
                     (case c
                       ((#\Space #\Newline #\Tab #\Page)
                        (send! self :out (new-newline (token-position tok))))
                       (otherwise (forward-token)))))
                  (t (forward-token))))))))))
