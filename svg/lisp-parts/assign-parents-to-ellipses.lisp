(in-package :arrowgram)

(paip::<- (assign-parents-to-ellipses-query)
    (ellipse ?eid)
    (component ?comp)
    !
    (paip::add-clause `((parent ?comp ?eid))))

(defun assign-parents-to-ellipses ()
  (paip::prove-all '((assign-parents-to-ellipses-query)) paip::no-bindings))

;;;   (prove-all '((ellipse ?eid)
;;;                (component ?comp)
;;;                !
;;;                (add-clause `((parent ?comp ?eid))))
;;;              no-bindings))
