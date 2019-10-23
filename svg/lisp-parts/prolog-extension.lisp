(in-package :paip)

;; prolog

(defun true/0 (cont)
  (funcall cont))

(defun halt/0 (cont)
  (declare (ignore cont))
  )

(defun pl-true/0 (cont)
  (declare (ignore cont))
  )

(defun directive/0 (cont)
  (funcall cont))

(defun readfb/1 (x cont)
  (declare (ignore x))
  (funcall cont))

(defun writefb/0 (cont)
  (funcall cont))


;; lisp

(defun directive ()
  )