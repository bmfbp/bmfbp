;; in SVG, lines start with an absolute move (absm) followed by pair of coords (absl)
;; we want line segments to be (x1,y1,x2,y2)


(defun fixup-line (list x1 y1)
  (when list
    (if (and (= 1 (length list))
             (eq 'z (first (first list))))
        `((z))
      (let* ((absl (first list))
             (x2 (second absl))
             (y2 (third absl)))
        (cons `(line-segment ,x1 ,y1 ,x2 ,y2)
              (fixup-line (rest list) x2 y2))))))

(defun fix-lines (list)
  (assert (listp list) () "fix-lines list=/~a/" list)

  (if (listp (car list))
      (mapcar #'fix-lines list)
      (case (car list)
	
	(translate
	 (let ((pair (second list))
               (tail (third list)))
	   (if (list-of-lists-p tail)
               `(translate ,pair ,(mapcar #'fix-lines tail))
               (error "fix-lines: badly formed translate /~A/~%" list))))
	
	((rect text component ellipse dot speechbubble) list)
	
	(line
	 (let* ((absm (second list))
		(x1 (second absm))
		(y1 (third absm)))
	   `(line ,@(fixup-line (rest (rest list)) x1 y1))))
	
	(otherwise
	 (error (format nil "bad format in fixup-line /~A/" list))))))
  
