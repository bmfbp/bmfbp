(ql:quickload :paiprolog)

(paiprolog:<- (geometry-center-x id430 11855))

(defun forall (id)
  (paiprolog:prolog-collect (?left) (geometry-left-x id ?left)))

(defun main ()
  (forall 'id430))
