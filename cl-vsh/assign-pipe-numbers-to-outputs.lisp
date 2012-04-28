;; fbp says that each output of a component can only go one place, but outputs from
;; multiple components can be tied together and arrive at a single component's input

;; to assign pipe numbers, we (1) assign a unique pipe index to each input, then (2) find
;; all outputs that go to each input and give them the same pipe index

;; this is step (2)

(load "io")

(declaim (ftype function assign-pipe-number find-edge-for-source find-sink get-pipe))

(defun assign-pipe-numbers (facts)
  (let ((component-id nil)
	(component-info nil))
    (maphash #'(lambda (k v)
		 (when-match (componentf 'component v)
			     (setf component-id k
				   component-info v))
		 (assign-pipe-number k v facts)) facts)))

(defun assign-pipe-number (id info facts)
  (when-match (p 'type info)
	      (when (eq (obj p) 'port)
		(when-match (p 'source info)
			    (let ((edge-info (find-edge-for-source (id p) facts)))
			      (let ((sink-info (find-sink edge-info facts)))
				(let ((pipe (get-pipe sink-info)))
				  (setf (gethash 'pipe-num info)
					(list 'pipe-num id pipe)))))))))

(defun find-edge-for-source (port facts)
  (maphash #'(lambda (id info)
	       (declare (ignorable id))
	       (when-match (e 'edge info)
			   (let-match (s 'source info)
				      (when (eq (obj s) port)
					(return-from find-edge-for-source info)))))
	   facts)
  (assert nil))

(defun find-sink (info facts)
  (let-match (s 'sink info)
	     (gethash (obj s) facts)))

(defun get-pipe (info)
  (let-match (p 'pipe-num info)
	     (obj p)))

(defun main (argv)
  (declare (ignorable argv))
  (read-write-facts #'assign-pipe-numbers *standard-input* *standard-output*)
  0)

;(main)