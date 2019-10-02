(in-package :arrowgram)

(defun assign-parents-to-ellipses ()
  (let ((all-ellipses (all-solutions (ellipse ?eid)))
        (main-list (all-solutions (component ?component))))
    (let ((main-component (fetch-value '?component (first main-list))))
      (mapc #'(lambda (eid-dotted-pair-list)
                (let ((eid (fetch-value '?eid eid-dotted-pair-list)))
                  (paip::add-clause `((parent ,main-component ,eid)))))
            all-ellipses))))


