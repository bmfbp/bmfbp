(in-package :e/util)

(defun in-list-p (list object equality-test)
  (mapc #'(lambda (item)
            (let ((exists (funcall equality-test item object)))
              (when exists
                (return-from in-list-p item))))
        list)
  nil)

(defun ensure-in-list (list object equality-test fmt-msg &rest fmt-args)
  (unless (in-list-p list object equality-test)
    (error (apply #'cl:format nil fmt-msg fmt-args))))

(defun ensure-not-in-list (list object equality-test fmt-msg &rest fmt-args)
  (mapc #'(lambda (item)
            (let ((exists (funcall equality-test item object)))
              (when exists
                (error (apply #'cl:format nil fmt-msg fmt-args)))))
        list))

(defparameter *sent-events* nil)
(defparameter *logs* nil)
(defparameter *wire-number* 0)

(defun reset ()
  (setf *sent-events* nil)
  (setf *wire-number* 0))

(defun get-wire-number ()
  (prog1
      *wire-number*
    (incf *wire-number*)))

