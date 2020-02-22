(in-package :arrowgrams/compiler)

(defclass parens (e/part:code) ())
(defmethod e/part:busy-p ((self parens)) (call-next-method))
; (:code parens (:token) (:out :error) #'e/part:react #'e/part:first-time)


(defmethod e/part:first-time ((self parens)))

(defmethod e/part:react ((self parens) (e e/event:event))
  (ecase (e/event::sym e)
    (:token
     (let ((tok (e/event:data e)))
       (flet ((new-lpar () (make-token :kind :lpar :text #\( :position (token-position tok)))
              (new-rpar () (make-token :kind :rpar :text #\) :position (token-position tok)))
              (forward-token () (@send self :out (@data self e))))
         (cond ((eq :character (token-kind tok))
                (let ((c (token-text tok)))
                  (case c
                    (#\(
                     (@send self :out (new-lpar)))
                    (#\)
                     (@send self :out (new-rpar)))
                    (otherwise (forward-token)))))
               (t (forward-token))))))))
