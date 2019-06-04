;; we could assign id's to the various lines and calculate where they start and end, in Prolog
;; but,,, we already have the lines described by sequence line-segments, we only really need to know where a line starts
;; and where it ends, we can do that easily in Lisp

(defun grid (x grid-size)
  (floor (* grid-size (floor (/ (+ x (1- grid-size)) grid-size)))))

(defun grid10 (x)
  (grid x 10))

(defun collapse-lines (list)
  (assert (listp list) () "collapse-lines list=/~a/" list)

  (if (listp (car list))
      (mapcar #'collapse-lines list)
      
      (case (car list)
	
	(translate
	 (let ((pair (second list))
               (tail (third list)))
	   (if (list-of-lists-p tail)
               `(translate ,pair ,(mapcar #'collapse-lines tail))
               (error "badly formed translate"))))
	
	((rect text arrow component ellipse dot speechbubble metadata) 
	 list)
	
	(line
	 (let ((start (second list))
               (end (car (last list))))
	   `(line (line-begin ,(second start) ,(third start))
		  (line-end ,(grid10 (fourth end)) ,(grid10 (fifth end))))))
	
	(otherwise
	 (error (format nil "bad format in collapse-lines /~A/" list))))))

