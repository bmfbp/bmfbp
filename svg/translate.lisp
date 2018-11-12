;; recursively remove "translations" and apply them to all coords in scope

(defun translate-rect (x y list)
  `(,(+ x (second list)) ,(+ y (third list)) ,(third list) ,(fourth list)))

(defun translate-one-move (xypair movelist)
  ;; for lines
  (assert (listp movelist))
  (assert (symbolp (first movelist)))
  (when (second movelist) 
    (assert (numberp (second move)))
    (when (third move) 
      (assert (numberp (third move)))))
  (case (first move)
    (Z '(z))
    (absm `(move-absolute ,(+ x (second move))
			  ,(+ y (third move))))
    (relm `(move-relative ,(+ x (second move))
			  ,(+ y (third move))))
    (absl `(stroke-absolute ,(+ x (second move))
			     ,(+ y (third move))))
    (rell `(stroke-relative ,(+ x (second move))
			    ,(+ y (third move))))
    (otherwise
     (format t "move = ~A~%" move)
     (error "one-move not handled"))))


(defun translate (pair list)
  (labels ((translate-one (pair list)
	     (format *error-output* "translate x=~a y=~a list=~a~%"
		     x y list)
	     (unless (and list (listp list))
	       (format *error-output* "wrong format: ~a~%" list)
	       (error "wrong format"))
	     (case (car list)
	       (translate 
		(let ((pair (second list)))
		  (assert pair)
		  (assert (listp pair))
		  (assert (= 2 (length pair)))
		  (assert (numberp (first pair)))
		  (assert (numberp (second pair)))
		  (if (text-p list)
		      (multiple-value-bind (x y txt) 
			  (parse-text-item list)
			`(text 
			  ,(+ x (first pair)) 
			  ,(+ y (second pair)) 
			  ,txt))
		      (car 
		       (translate 
			(list
			 (+ x (first pair)) 
			 (+ y (second pair)))
			list)))))

	       (line (cons 'line (mapcar 
				  #'(lambda (move) 
				      (translate-one-move x y move))
				  (cdr list))))

	       (rect `(rect ,@(translate-rect x y (cdr list))))

	       (otherwise 
		(format t "~a~%" list)
		(error "not handled")))))

    (mapcar #'(lambda (one)
		(translate-one x y one))
	    list)))


