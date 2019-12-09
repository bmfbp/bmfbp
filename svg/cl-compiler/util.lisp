(in-package :arrowgrams/compiler/reader)

(defparameter *fb* nil)

(defmethod read-prolog-fb ((self e/part:part) file-name)
  (let ((prolog-line nil))
    (flet ((rdline () (setf prolog-line (read-line f nil :EOF))))
      (with-open-file (f file-name :direction :input)
        (rdline)
        (@:loop
         (@:exit-when (eq :EOF line))
         (add-prolog-fact self prolog-line)
         (rdline))))))

(defun add-prolog-fact (self prolog-line)
  ;;(cl-ppcre:regex-replace "(a)(b)(c)" "abc" (list 2 1 0))
  (let ((rewritten (cl-ppcre:regex-replace "^\([^(+]\)([^))\." prolog-line (list "(" 0 1 ")"))))
    (@send self :out rewritten)))

