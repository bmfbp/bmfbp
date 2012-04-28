(load "io")

(declaim (ftype function assign-fd-numbers assign-fd-number assign-fd append-fd next-fd))

(defun main (argv)
  (declare (ignorable argv))
  (read-write-facts #'assign-fd-numbers *standard-input* *standard-output*)
  0)

(defun assign-fd-numbers (facts)
  (let ((component-id nil)
	(component-info nil))
    (maphash #'(lambda (k v)
		 (when-match (componentf 'component v)
		    (setf component-id k
			  component-info v))
		 (assign-fd-number k v facts)) facts)))

(defun assign-fd-number (id info facts)
  (when-match (p 'type info)
     (when (eq (obj p) 'port)
       (let-obj-match (name 'portname info)
          (cond ((string= name "in")
                 (assign-fd id info 0 facts))
                ((string= name "out")
                 (assign-fd id info 1 facts))
                ((string= name "err")
                 (assign-fd id info 2 facts))
                (t
                 (assign-fd id info (next-fd info facts) facts)))))))

(defun assign-fd (id info n facts)
  (setf (gethash 'fd-num info)
        (list 'fd-num id n))
  (let-obj-match (parent 'parent info)
    (let-obj-match (source 'source info)
      (let-obj-match (pipe 'pipe-num info)
        (let ((pinfo (gethash parent facts)))
	  (append-fd source pipe n parent pinfo))))))

(defun append-fd (source-p pipe fd id info)
  (let ((dir (if source-p 'source-fds 'sink-fds)))
    (let-obj-match (fd-list dir info)
      (setf (gethash dir info) (list dir id (cons (cons pipe fd) fd-list))))))

(defun next-fd (port-info facts)
  (let-obj-match (parent-id 'parent port-info)
     (assert (and parent-id (atom parent-id)))
     (let ((parent-info (gethash parent-id facts)))
       (let-match (nextf 'next-fd parent-info)
		  (let ((next (if nextf
				  (obj nextf)
				  3)))
		    (setf (gethash 'next-fd parent-info)
			  (list 'next-fd parent-id (1+ next)))
		    next)))))

;(main)