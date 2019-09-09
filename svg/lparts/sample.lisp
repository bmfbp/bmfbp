(ql:quickload :paiprolog)

(defparameter *id* nil)

(defun main ()
  (let ((*id* 'id430))
    (paiprolog::clear-db)

    (paiprolog:<- (geometry-left-x id429 11705))
    (paiprolog:<- (geometry-left-x id426 6910))
    (paiprolog:<- (geometry-left-x id415 9410))
    (paiprolog:<- (geometry-left-x id398 12010))
    (paiprolog:<- (geometry-left-x id379 9410))
    
    (paiprolog:<- (rect id426))
    (paiprolog:<- (rect id415))
    (paiprolog:<- (rect id398))
    (paiprolog:<- (rect id379))

    (let ((all-rects (paiprolog::prolog-collect (?id)
                       (rect ?id))))
      (format *standard-output* "~&all-rects=~S~%" all-rects)
      (mapcar #'(lambda (r)
                  (let ((*id* r))
                    (let ((xs (paiprolog::prolog-collect (?id ?x)
                                (paiprolog::lisp ?id *id*)
                                #+nil(paiprolog::lisp (format *standard-output* "~&id=~S~%" ?id))
                                (geometry-left-x ?id ?x))))
                    xs)))
              all-rects))))
  
