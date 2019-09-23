(in-package :arrowgram)

(defun assign-parents-to-ellipses ()
  (let ((all-ellipses (all-solutions (ellipse ?eid)))
        (main-list (all-solutions (component ?component))))
    (format *error-output* "~&~%all-ellipses /~S/ main-list=/~S/~A~%" all-ellipses main-list (length main-list))
    (let ((main-component (fetch-value '?component (first main-list))))
      (format *error-output* "~&main-component /~S/~%" main-component)
      (mapc #'(lambda (eid-dotted-pair)
                (let ((eid (cdr eid-dotted-pair)))
                  (paip::add-clause `((parent ,main-component ,eid)))))
            all-ellipses))))


