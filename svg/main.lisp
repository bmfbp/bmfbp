;; test with Ken's output (already (list list)))

(setf *default-pathname-defaults* #p"~/Dropbox/Projects/vsh/svg/")

(defun main (f) 
  (let ((list (read f)))
    (assert (eq 'translate (first list)))
    (let ((pair (second list)))
      (assert pair)
      (assert (listp pair))
      (assert (= 2 (length pair)))
      (assert (numberp (first pair)))
      (assert (numberp (second pair)))
      (convert-arrows (translate (first pair) (second pair) (third list))))))

(defun run (argv)
  (declare (ignorable argv))
  (tofb 
   *standard-output* 
   (main *standard-input*)))
