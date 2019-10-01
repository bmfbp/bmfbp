;; Convention - any line ending in (Z) is actually an arrow

(defun fix-arrows (list)
  (assert (listp list) nil "fix-arrows list=/~a/" list)

  (if (listp (car list))
      (mapcar #'fix-arrows list)

    (case (car list)
      
      (translate
       (let ((pair (second list))
             (tail (third list)))
         (if (list-of-lists-p tail)
             `(translate ,pair ,(mapcar #'fix-arrows tail))
           (die (format nil "fix-arrows: badly formed translate /~A/~%" list)))))
      
      ((rect text arrow component ellipse dot speechbubble metadata nothing) 
       list)
      
      (line
       (if (eq 'z (first (first (last list))))
           ;; this is specific to draw.io - arrows in draw.io are of the form "(LINE (LINE-SEGMENT 310.0 178.88 306.5 171.88) (LINE-SEGMENT 306.5 171.88 310.0 173.63) (LINE-SEGMENT 310.0 173.63 313.5 171.88) (Z))"
           ;; "line" becomes "arrow" and we drop everything but the 2nd pair in the 3rd coord, which is the tip of the arrow
           (progn
             (let* ((tip-triple (third list))
                    (tip-x (fourth tip-triple))
                    (tip-y (fifth tip-triple)))
               `(arrow ,tip-x ,tip-y)))
         list))
    
    (otherwise
     (die (format nil "bad format in fix-arrows /~A/" list))))))

