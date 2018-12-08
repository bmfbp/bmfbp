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

(defun to-prolog (list strm)
  (assert (listp list))
  (if (listp (car list))

      (progn
        (to-prolog (car list) strm)
        (mapc #'(lambda (x) (to-prolog x strm)) (rest list)))

    (let ((new-id (next-id)))
      (case (car list)

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
               (format strm "line(~A,'').~%line_begin_x(~A,~A).~%line_begin_y(~A,~A).~%line_end_x(~A,~A).~%line_end_y(~A,~A).~%"
                       new-id new-id x1 new-id y1 new-id x2 new-id y2)))))
        
        (rect
         (destructuring-bind (rect-sym x1 y1 w h)
             list
           (declare (ignore rect-sym))
           (format strm "rect(~A,'').~%rect_x(~A,~A).~%rect_y(~A,~A).~%rect_w(~A,~A).~%rect_h(~A,~A).~%"
                   new-id new-id x1 new-id y1 new-id w new-id h)))
        
        (text
         (destructuring-bind (text-sym str x1 y1 w h)
             list
           (declare (ignore text-sym))
	   (if (all-digits-p str)
               (format strm "text(~A,~A).~%text_x(~A,~A).~%text_y(~A,~A).~%text_w(~A,~A).~%text_h(~A,~A).~%"
                       new-id str new-id x1 new-id y1 new-id w new-id h)
             (format strm "text(~A,'~A').~%text_x(~A,~A).~%text_y(~A,~A).~%text_w(~A,~A).~%text_h(~A,~A).~%"
                     new-id str new-id x1 new-id y1 new-id w new-id h))))
           
        (arrow
         (destructuring-bind (arrow-sym x1 y1)
             list
           (declare (ignore arrow-sym))
           (format strm "arrow(~A,'').~%arrow_x(~A,~A).~%arrow_y(~A,~A).~%"
                   new-id new-id x1 new-id y1)))

        (otherwise
         (error (format nil "bad format in toprolog /~A/" list))))))
      
  (values))

    
