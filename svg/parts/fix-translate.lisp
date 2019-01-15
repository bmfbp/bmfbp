;; apply all translations in lisp - probably could be done in Prolog

(defun fix-one-translate (x y list)
  (assert (listp list) () "fix-one-translate 1 x=~a y= ~a list=/~a/" x y list)

  (if (listp (car list))
      (mapcar #'(lambda (l)
                  (fix-one-translate x y l))
              list)

      (case (car list)
	(translate
	 (let ((pair (second list))
               (tail (third list)))
	   (assert (list-of-lists-p tail) () "fix-one-translate 2 x=~a y= ~a list=/~a/" x y list)
	   (mapcar #'(lambda (item) (fix-one-translate (+ x (first pair)) (+ y (second pair)) item)) tail)))
	
	(rect
	 (destructuring-bind (sym x1 y1 x2 y2)
             list
	   (declare (ignore sym))
	   `(rect ,(+ x x1) ,(+ y y1) ,(+ x x2) ,(+ y y2))))

	(line
	 (destructuring-bind (line-sym begin end)
             list
	   (declare (ignore line-sym))
	   (destructuring-bind (begin-sym x1 y1)
               begin
             (declare (ignore begin-sym))
             (destructuring-bind (end-sym x2 y2)
		 end
               (declare (ignore end-sym))
               `(line (begin-line ,(+ x x1) ,(+ y y1))
                      (end-line ,(+ x x2) ,(+ y y2)))))))

	(arrow
	 (destructuring-bind (arrow-sym x1 y1)
             list
	   (declare (ignore arrow-sym))
	   `(arrow ,(+ x x1) ,(+ y y1))))

	(text
	 ;; text is in (x y w h) format
	 (destructuring-bind (text-sym str x1 y1 w h)
             list
	   (declare (ignore text-sym))
	   `(text ,str ,(+ x x1) ,(+ y y1) ,w ,h)))

	(otherwise
	 (error (format nil "bad format in fix-one-translate /~A ~A ~A/" x y list))))))

(defun fix-translates (list)
  (assert (listp list) () "fix-translates 3 list=/~a/" list)

  (if (listp (car list))
      (mapcar #'fix-translates list)

      (case (car list)
	
	(translate
	 (let ((pair (second list))
               (tail (third list)))
	   (assert (list-of-lists-p tail) () "fix-translates 4 list=/~a/" list)
	   (mapcar #'(lambda (item) (fix-one-translate (first pair) (second pair) item)) tail)))
	
	((rect text arrow line)
	 list)
	
	(otherwise
	 (error (format nil "bad format in fix-translates /~A/" list))))))

