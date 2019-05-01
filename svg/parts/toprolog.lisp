(defun all-digits-p (str)
  (let ((i (1- (length str))))
    (loop
       (case (schar str i)
	 ((#\0 #\1 #\2 #\3 #\4 #\5 #\5 #\6 #\7 #\8 #\9)
	  (when (< (decf i)0)
	    (return t)))	  
	 (otherwise
	  (return-from all-digits-p nil)))))
  t)

(defun next-id ()
  (gensym "id"))

(defparameter *p* 20)  ;; port width and height - play with this if you get "no parent for box" errors

(defun to-prolog (list strm)
  (assert (listp list) () "to-prolog list=/~a/" list)
  (if (listp (car list))

      (progn
        (to-prolog (car list) strm)
        (mapc #'(lambda (x) (to-prolog x strm)) (rest list)))

    (let ((new-id (next-id)))
      (case (car list)

	(component
	 (format strm "component('~A').~%" (second list)))

        (line
	 (let ((begin-id (next-id))
	       (end-id (next-id))
	       (edge-id (next-id)))
           (destructuring-bind (line-sym begin end)
               list
             (declare (ignore line-sym))
             (destructuring-bind (begin-sym x1 y1)
		 begin
               (declare (ignore begin-sym))
               (destructuring-bind (end-sym x2 y2)
                   end
		 (declare (ignore end-sym))
		 (format strm "line(~A).~%"	new-id)

		 (format strm "edge(~A).~%" edge-id)
		 (format strm "source(~A,~A).~%" edge-id begin-id)
		 (format strm "eltype(~A,port).~%" begin-id)
		 (format strm "bounding_box_left(~A,~A).~%" begin-id (- x1 *p*))
		 (format strm "bounding_box_top(~A,~A).~%" begin-id (- y1 *p*))
		 (format strm "bounding_box_right(~A,~A).~%" begin-id (+ x1 *p*))
		 (format strm "bounding_box_bottom(~A,~A).~%" begin-id (+ y1 *p*))
		 
		 (format strm "sink(~A,~A).~%" edge-id end-id)
		 (format strm "eltype(~A,port).~%" end-id)
		 (format strm "bounding_box_left(~A,~A).~%" end-id (- x2 *p*))
		 (format strm "bounding_box_top(~A,~A).~%" end-id (- y2 *p*))
		 (format strm "bounding_box_right(~A,~A).~%" end-id (+ x2 *p*))
		 (format strm "bounding_box_bottom(~A,~A).~%" end-id (+ y2 *p*)))))))
        
        (rect
	 ;; rect is given as {top-left, width, height}
         (destructuring-bind (rect-sym x1 y1 w h)
             list
           (declare (ignore rect-sym))
           (format strm "rect(~A).~%eltype(~A,box).~%~%geometry_left_x(~A,~A).~%geometry_top_y(~A,~A).~%geometry_w(~A,~A).~%geometry_h(~A,~A).~%"
                   new-id new-id new-id x1 new-id y1 new-id w new-id h)))

	(ellipse
         (destructuring-bind (sym x1 y1 w h)
             list
           (declare (ignore sym))
           (format strm "ellipse(~A).~%eltype(~A,ellipse).~%~%geometry_center_x(~A,~A).~%geometry_center_y(~A,~A).~%geometry_w(~A,~A).~%geometry_h(~A,~A).~%"
                   new-id new-id new-id x1 new-id y1 new-id w new-id h)))

	(dot
         (destructuring-bind (sym x1 y1 w h)
             list
           (declare (ignore sym))
           (format strm "dot(~A).~%eltype(~A,dot).~%~%geometry_center_x(~A,~A).~%geometry_top_y(~A,~A).~%geometry_w(~A,~A).~%geometry_h(~A,~A).~%"
                   new-id new-id new-id x1 new-id y1 new-id w new-id h)))


        (text
	 ;; text is given as {center-x, top-y, width/2, height}
         (destructuring-bind (text-sym str x1 y1 w h)
             list
           (declare (ignore text-sym))
	   (if (all-digits-p str)
               (format strm "text(~A,~A).~%geometry_center_x(~A,~A).~%geometry_top_y(~A,~A).~%geometry_w(~A,~A).~%geometry_h(~A,~A).~%"
                       new-id str new-id x1 new-id y1 new-id w new-id h)
             (format strm "text(~A,'~A').~%geometry_center_x(~A,~A).~%geometry_top_y(~A,~A).~%geometry_w(~A,~A).~%geometry_h(~A,~A).~%"
                     new-id str new-id x1 new-id y1 new-id w new-id h))))
           
        (arrow
         (destructuring-bind (arrow-sym x1 y1)
             list
           (declare (ignore arrow-sym))
           (format strm "arrow(~A).~%arrow_x(~A,~A).~%arrow_y(~A,~A).~%"
                   new-id new-id x1 new-id y1)))

        (otherwise
         (error (format nil "bad format in toprolog /~A/" list))))))
      
  (values))

    
