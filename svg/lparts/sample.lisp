(defparameter *id* nil)

(defun assert-facts ()
    (<- (rect id426))
    (<- (rect id415))
    (<- (rect id398))
    (<- (rect id379))
    (<- (eltype id379 box))
    (<- (geometry-h id379 800))
    (<- (geometry-w id379 800))
    (<- (geometry-left-x id379 9410))
    (<- (geometry-top-y id379 00))

#|
    (<- (geometry-left-x id429 11705))
    (<- (geometry-left-x id426 6910))
    (<- (geometry-left-x id415 9410))
    (<- (geometry-left-x id398 12010))
    (<- (geometry-left-x id379 9410))
    
    (<- (rect id426))
    (<- (rect id415))
    (<- (rect id398))
    (<- (rect id379))
|#
)

(defun strip-vars (var-name solutions)
  " return solutions as a list w/o var-name ; assumed that solutions is a list of lists where each inner list is (name . val)"
  (mapcar #'(lambda (lis)
              (assert (= 1 (length lis)))
              (let ((cell (car lis)))
                (when (eq var-name (car cell))
                  (cdr cell))))
          solutions))

(defun main ()
  (let ((*id* 'id430))
    (clear-db)
    (assert-facts)

    (let ((all-solutions (prove-all '((rect ?id) (geometry-left-x ?id ?x)) no-bindings)))
      (format *standard-output* "~&all-solutions ~S~%" all-solutions))
    
    #+nil(let ((all-rects (paiprolog::prolog-collect (?id)
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
  
