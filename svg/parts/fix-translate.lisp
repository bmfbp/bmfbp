;; apply all translations in lisp - probably could be done in Prolog

(defun fix-one-translate (x y list)
  (assert (listp list) () "fix-one-translate 1 x=~a y= ~a list=/~a/" x y list)

  (if (listp (car list))
      (mapcar #'(lambda (l)
                  (fix-one-translate x y l))
              list)
      (let ()
	(case (car list)
	  (translate
	   (let ((pair (second list))
		 (tail (third list)))
	     (assert (list-of-lists-p tail) () "fix-one-translate 2 x=~a y= ~a list=/~a/" x y list)
	     (mapcar #'(lambda (item) (fix-one-translate (+ x (first pair)) (+ y (second pair)) item)) tail)))

	  (rect
	   (destructuring-bind (sym x1 y1 w h)
               list
	     (declare (ignore sym))
	     `(rect ,(+ x x1) ,(+ y y1) ,w ,h)))

	  (speech-bubble
	   ;; speech-bubble is in (speech-bubble p1 p2 p3 p4 p5 p6 p7 (z)) format
	   ;; where p1 is (absm x y), other p's are (absl x y) format
	   ;; p1 is top-left, p2 if top-right, p3 is bottom-right, p7 is bottom-left
	   (destructuring-bind (text-sym p1 p2 p3 p4 p5 p6 p7 zed) 
               list
	     (declare (ignore text-sym zed p4 p5 p6 p7))
	     (let ((x1 (first p1))
		   (y1 (second p1)))
	       (let ((w (- (first p2) x1))
		     (h (- (second p3) y1)))
		 `(comment ,(+ x x1) ,(+ y y1) ,w ,h)))))

	  (ellipse
	   (destructuring-bind (sym x1 y1 x2 y2)
               list
	     (declare (ignore sym))
	     `(ellipse ,(+ x x1) ,(+ y y1) ,x2 ,y2)))

	  (dot
	   (destructuring-bind (sym x1 y1 x2 y2)
               list
	     (declare (ignore sym))
	     `(dot ,(+ x x1) ,(+ y y1) ,x2 ,y2)))

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

	  (metadata
	   list )

	  (otherwise
	   (die (format nil "bad format in fix-one-translate /~A ~A ~A/" x y list)))))))

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
	
	((rect text arrow line component ellipse dot speechbubble metadata)
	 list)
	
	(otherwise
	 (die (format nil "bad format in fix-translates /~A/" list))))))

