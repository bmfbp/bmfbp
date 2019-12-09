(in-package :arrowgrams/compiler/reader)

; (:code reader (:file-name) (:string-fact :eof :fatal) #'arrowgrams/compiler/reader::react)

(defmethod first-time ((self e/part:part))
  ;; nothing
  )

(defmethod react ((self e/part:part) ev-file-name)
  (read-prolog-fb self (e/event:data ev-file-name)))

(defmethod read-prolog-fb ((self e/part:part) file-name)
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
      (cl-event-passing-user:@send self :string-fact rw2))))

