(in-package :arrowgram)

(paiprolog:<-- (assign-parents-to-ellipses-query)
    (ellipse ?eid)
    (component ?comp)
    !
    (add-clause `((parent ?comp ?eid))))

(defun assign-parents-to-ellipses ()
  (prove-all '((assign-parents-to-ellipses-query)) no-bindings))
