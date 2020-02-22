(in-package :arrowgrams/compiler)

(defclass reader (compiler-part) ())

; (:code reader (:file-name) (:string-fact :eof :error))

(defmethod compiler-part-initially ((self reader))
  )
  
(defmethod compiler-part-run ((self reader) (e e/event:event))
  (ecase (@pin self e)
    (:file-name
     (read-prolog-fb self (@data self e)))
    (:in-stream
     (read-prolog-stream self (@data self e)))))

(defmethod read-prolog-fb ((self reader) file-name)
  (with-open-file (f file-name :direction :input)
      (read-prolog-stream self f)))

(defmethod read-prolog-stream ((self reader) f)
  (let ((prolog-line nil))
    (flet ((rdline () (setf prolog-line (read-line f nil :EOF))))
      (rdline)
      (@:loop
        (@:exit-when (eq :EOF prolog-line))
        (add-prolog-fact self prolog-line)
        (rdline)))
    (@send self :eof :eof)))

(defun add-prolog-fact (self prolog-line)
  ;;ex. (cl-ppcre:regex-replace "(a)(b)(c)" "abc" (list 2 1 0)) --> "cba"
  (let ((rw1 (cl-ppcre:regex-replace "^([^\\(]+)\\(([^\\)]+)\\)\\." prolog-line (list "(" 0 " " 1 ")"))))
    (let ((rw2
           (if (and (> (length prolog-line) 3)
                    (string= "text" (subseq prolog-line 0 4)))
               (cl-ppcre:regex-replace "," rw1 " ")
             (cl-ppcre:regex-replace-all "," rw1 " "))))
      (@send self :string-fact rw2))))

