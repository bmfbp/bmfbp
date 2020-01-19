(in-package :arrowgrams/compiler/back-end)

; (:code parens (:token) (:out :error) #'parens-react #'parens-first-time)


(defmethod parens-first-time ((self e/part:part))
  )

(defmethod parens-react ((self e/part:part) (e e/event:event))
  (ecase (e/event::sym e)
    (:token
     (let ((tok (e/event:data e)))
       (flet ((new-lpar () (make-token :kind :lpar :text #\( :position (token-position tok)))
              (new-rpar () (make-token :kind :lpar :text #\) :position (token-position tok)))
              (forward-token ()
                (send-event! self :out e)))
         (cond ((eq :character (token-kind tok))
                (let ((c (token-text tok)))
                  (case c
                    (#\(
                     (send! self :out (new-lpar)))
                    (#\)
                     (send! self :out (new-rpar)))
                    (otherwise (forward-token)))))
               (t (forward-token))))))))
