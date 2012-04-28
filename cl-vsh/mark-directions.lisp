(load "io")

(defun mark-source (fact facts)
  (let ((port-id (obj fact)))
    (let ((port-info (gethash port-id facts)))
      (when-match (s 'sink port-info)
        (vsherror "port ~A cannot simultaneously be a source and sink" port-id))
      (when-match (s 'source port-info)
        (return-from mark-source)) ;; already marked
      (setf (gethash 'source port-info) (list 'source port-id)))))

(defun mark-sink (fact facts)
  (let ((port-id (obj fact)))
    (let ((port-info (gethash port-id facts)))
      (when-match (s 'source port-info)
        (vsherror "port ~A cannot simultaneously be a sink and sink" port-id))
      (when-match (s 'sink port-info)
        (return-from mark-sink)) ;; already marked
      (setf (gethash 'sink port-info) (list 'sink port-id)))))

(defun mark-direction (id info facts)
  ;; create a new "direction" fact for every port
  (declare (ignorable id))
  (when-match (e 'edge info)
      (when-match (s 'source info)
        (mark-source s facts))
      (when-match (s 'sink info)
        (mark-sink s facts))))

(defun mark-directions (facts)
  (maphash #'(lambda (k v) (mark-direction k v facts)) facts))

(defun main (argv)
  (declare (ignorable argv))
  (read-write-facts #'mark-directions *standard-input* *standard-output*)
  0)

;(main)