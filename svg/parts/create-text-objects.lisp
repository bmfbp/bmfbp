(defparameter *default-font-width* 2) ;; kludge - Draw.IO should be able to tell us the extent of the string, but doesn't
(defparameter *default-font-height* 12)


(defun matches-text-item-p (tail)
  (stringp (first tail)))

(defun text-part (tail)
  (first tail))

(defun get-metadata-len (text)
  ;; faking it for now, too hard to calculate, let's wait for a better editor
  ;; in prolog, the text will match a rounded rectangle if its upper-left
  ;; corner is in the rounded rectangle (and we will mostly ignore the width)
  (declare (ignore text))
  10)

(defun create-text-objects (list)
  (assert (listp list))
  (format *error-output* "list: ~S~%" list)
  (if (listp (car list))
      (mapcar #'create-text-objects list)
      (case (car list)
	
	(translate
	 (flet ((failure () (die (format nil "badly formed translate /~A/~%" list))))
	   (let ((pair (second list))
		 (tail (third list)))

	     ;; (when (and
	     ;; 	    (= 1 (length tail))
	     ;; 	    (listp (first tail))
	     ;; 	    (stringp (first (first tail)))
	     ;; 	    (null  (second (first tail))))
	     ;;   (format *error-output* "~%~%fixed bug2 in create-text-objects.lisp~%~%")
	     ;;   (setf tail (first tail)))
	     
	     (cond ((list-of-lists-p tail)
                    `(translate ,pair ,(mapcar #'create-text-objects tail)))

		   ((matches-text-item-p tail)
                    ;; (translate (N M) ("emit")) --> ((translate (N M) ((text "emit" 0 0 w/2 h))))
                    (let ((text (text-part tail)))
                      (let ((half-width (/ (* (length text) *default-font-width*) 2)))
			`((translate ,pair
                                     ((text ,text 
                                            0
                                            0
                                            ,half-width
                                            ,*default-font-height*)))))))

		   (t (failure))))))
	
	((line rect component ellipse dot speechbubble)
	 list)

	(metadata
	 (if (and 
	      (= 2 (length list)) 
	      (stringp (second list)))
	     ;; (metadata "[lotsofstrings]") --> (metadata strid 0 0 w/2 h)
	     (let ((half-width (/ (* (get-metadata-len (second list)) *default-font-width*) 2)))
	       `(metadata ,(second list) 0 0 ,half-width ,*default-font-height*))
	     (die (format nil "badly formed metadata /~S/~%" list))))
	
	(otherwise
	 (die (format nil "~%bad format in create-text-objects /~S/~%" list))))))
