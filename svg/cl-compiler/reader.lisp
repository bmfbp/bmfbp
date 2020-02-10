(in-package :arrowgrams/compiler)

(defclass reader (e/part:part) ())

; (:code reader (:file-name) (:string-fact :eof :error))

(defmethod e/part:busy-p ((self reader))
  (call-next-method))

(defmethod e/part:first-time ((self reader))
  (call-next-method))
  
(defmethod e/part:react ((self reader) ev-file-name)
  (read-prolog-fb self (@data ev-file-name))
  (call-next-method))

(defmethod read-prolog-fb ((self reader) file-name)
  (let ((prolog-line nil))
    (with-open-file (f file-name :direction :input)
      (flet ((rdline () (setf prolog-line (read-line f nil :EOF))))
        (rdline)
        (@:loop
          (@:exit-when (eq :EOF prolog-line))
          (add-prolog-fact self prolog-line)
          (rdline))))
    (cl-event-passing-user::@send self :eof :eof)))

(defun add-prolog-fact (self prolog-line)
  ;;ex. (cl-ppcre:regex-replace "(a)(b)(c)" "abc" (list 2 1 0)) --> "cba"
  (let ((rw1 (cl-ppcre:regex-replace "^([^\\(]+)\\(([^\\)]+)\\)\\." prolog-line (list "(" 0 " " 1 ")"))))
    (let ((rw2 (cl-ppcre:regex-replace-all "," rw1 " ")))
      (@send self :string-fact rw2))))

