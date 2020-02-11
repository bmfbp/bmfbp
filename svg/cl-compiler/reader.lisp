(in-package :arrowgrams/compiler)

(defclass reader (e/part:part) ())

; (:code reader (:file-name) (:string-fact :eof :error))

(defmethod e/part:busy-p ((self reader))
  (call-next-method))

(defmethod e/part:first-time ((self reader)))
  
(defmethod e/part:react ((self reader) (ev-file-name e/event:event))
(format *standard-output* "~&reader gets /~S/~%" (@data self ev-file-name))
  (read-prolog-fb self (@data self ev-file-name)))

(defmethod read-prolog-fb ((self reader) file-name)
  (let ((prolog-line nil))
    (with-open-file (f file-name :direction :input)
      (flet ((rdline () (setf prolog-line (read-line f nil :EOF))))
        (rdline)
        (@:loop
          (@:exit-when (eq :EOF prolog-line))
          (add-prolog-fact self prolog-line)
          (rdline))))
    (@send self :eof :eof)))

(defun add-prolog-fact (self prolog-line)
  ;;ex. (cl-ppcre:regex-replace "(a)(b)(c)" "abc" (list 2 1 0)) --> "cba"
  (let ((rw1 (cl-ppcre:regex-replace "^([^\\(]+)\\(([^\\)]+)\\)\\." prolog-line (list "(" 0 " " 1 ")"))))
    (let ((rw2 (cl-ppcre:regex-replace-all "," rw1 " ")))
      (format *standard-output* "~&reader sends /~S/~%" rw2)
      (@send self :string-fact rw2))))

