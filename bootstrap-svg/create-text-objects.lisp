(defparameter *default-font-width* 12)
(defparameter *default-font-height* 12)


(defun matches-text-item-p (tail)
  (stringp (first tail)))

(defun text-part (tail)
  (first tail))

(defun create-text-objects (list)
  (assert (listp list))
  (case (car list)
    
    (translate
     (let ((pair (second list))
           (tail (third list)))
       (if (list-of-lists-p tail)
           `(translate ,pair ,(mapcar #'create-text-objects tail))
           (if (matches-text-item-p tail)
               (let ((text (text-part tail)))
		 (let ((half-width (/ (* (length text) *default-font-width*) 2)))
		   `((translate ,pair
			       ((text ,text 
				      0
				      0
				      ,half-width
				      ,*default-font-height*))))))
	       (error "badly formed translate /~A/~%" list)))))

    ((line rect)
     list)

    (otherwise
     (error (format nil "bad format in create-text-object /~A/" list)))))
