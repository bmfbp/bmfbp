;; fbp says that each output of a component can only go one place, but outputs from
;; multiple components can be tied together and arrive at a single component's input

;; to assign pipe numbers, we (1) assign a unique pipe index to each input, then (2) find
;; all outputs that go to each input and give them the same pipe index

(load "io")

(declaim (ftype function next-pipe assign-pipe-number assign-pipe))

(defvar *npipes* 0)

(defun assign-pipe-numbers (facts)
  (let ((component-id nil)
	(component-info nil))
    (setf *npipes* 0)
    (maphash #'(lambda (k v)
		 (when-match (componentf 'component v)
		    (setf component-id k
			  component-info v))
		 (assign-pipe-number k v))
	     facts)
    (setf (gethash 'n-pipes component-info)
	  (list 'n-pipes component-id *npipes*))))

(defun assign-pipe-number (id info)
  (when-match (p 'type info)
     (when (eq (obj p) 'port)
       (when-match (p 'sink info)
         (assign-pipe id info *npipes*)))))

(defun assign-pipe (id info n)
  (incf *npipes*)
  (setf (gethash 'pipe-num info)
        (list 'pipe-num id n)))

(defun main (argv)
  (declare (ignorable argv))
  (read-write-facts #'assign-pipe-numbers *standard-input* *standard-output*)
  0)

;(main)