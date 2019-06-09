(defun run1 (strm list)
  (let ((output *standard-output*))
    (flet ((else-dump-line () (write list :stream output) (terpri :output-stream output))
      (loop
	 (when (eq 'eof list) 
	   (exit-loop))
	 ;; (tranlsate (x y) ((translate (n m) ((metadata "str"))))) -->
	 ;; (translate (x y) (translate (n m) (metadata "str")))
	 ;;
	 ;; list = (translate (x y) ((translate (n m) ((metadata "str")))))
	 ;; inner-list =        (translate (n m) ((metadata "str")))
	 ;; meta-data-list =    ((metadata "str"))
	 ;; meta-data-clause =  (metatdata "str")
	 (if (and
	      (listp list)
	      (= 3 (length list))
	      (listp (first (third list))))
	     (let ((inner-list (first (third list))))
	       (if (and
		    (listp inner-list)
		    (= 3 (length inner-list))
		    (eq 'translate (first inner-list)))
		   (let ((meta-data-list (third inner-list)))
		     (if (listp meta-data-list)
			 (let ((meta-data-clause (first meta-data-list)))
			   (if (and
				(eq 'metadata (first meta-data-clause))
				(stringp (second meta-data-clause)))
			       (progn
				 (write `(translate
					  ,(second list)
					  (translate ,(second inner-list)
						     (metadata 
						      ,(second meta-data-clause))))
					:stream output)
				 (terpri :output-stream output))
			       (else-dump-line)))
			 (else-dump-line)))
		   (else-dump-line)))
	     (else-dump-line))
	 (setf list (read strm nil 'eof)))))))

(defun run (strm)
  (setf *debugger-hook* #'(lambda (c h)
			    (declare (ignore h))
			    (print c)
			    (abort)))
  (let ((list (read strm nil 'eof)))
    (assert (listp list) () "run not a list list=/~a/" list)
    (mapc 
     #'(lambda (l) (run1 strm l))
     list)))

#+lispworks
(defun main ()
  (run *standard-input*))

#+sbcl 
(defun main (argv)
  (declare (ignore argv))
  (run *standard-input*))

