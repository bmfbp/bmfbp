(in-package :arrowgram)

(defun assign-parents-to-ellipses ()
  (let ((cid (car (paiprolog:prolog-collect (?comp)
               (component ?comp))))
        (all-ellipses (paiprolog:prolog-collect (?e)
                        (ellipse ?e))))
    (format *error-output* "~&~%component ~s~%" cid)
    (format *error-output* "~&~%ellipses ~S~%" all-ellipses)
    (mapc #'(lambda (e)
              (paiprolog::add-clause `((parent ,cid ,e))))
          all-ellipses)))
                      

;;;     (destructuring-bind (comp eid) (car answer)
;;;       (paiprolog::add-clause `((parent ,comp ,eid))))))

