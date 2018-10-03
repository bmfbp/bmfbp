;; test with Ken's output (already (list list)))

(setf *default-pathname-defaults* #p"~/Dropbox/Projects/vsh/svg/")

(defun main (str) 
  (with-open-file (f (concatenate 'string str ".lisp") :direction :input)
    (let ((list (read f)))
      (assert (eq 'translate (first list)))
      (let ((pair (second list)))
	(assert pair)
	(assert (listp pair))
	(assert (= 2 (length pair)))
	(assert (numberp (first pair)))
	(assert (numberp (second pair)))
	(convert-arrows (translate (first pair) (second pair) (third list)))))))

(defun run (&optional (in-name "./sample") (out-name "./fb.pro"))
  (with-open-file (f out-name :direction :output :if-does-not-exist :create :if-exists :supersede)
      (tofb f (main in-name))))

