(in-package :arrowgram)

(defun assign-parents-to-ellipses ()
  (let ((all-ellipses (all-solutions (ellipse ?eid)))
        (main-component (fetch-value 'component (all-solutions (component ?component)))))
    (mapc #'(lambda (eid-dotted-pair)
              (let ((eid (cdr eid-dotted-pair)))
                (paip::add-clause `((parent ,main-component ,eid)))))
          all-ellipses)))


