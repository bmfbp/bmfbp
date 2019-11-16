(in-package :cl-event-passing-user)

(defun convert-JSON-to-Lisp-network (input-stream output-stream)
  (@initialize)
  (let ((top-level (@new-schematic :input-pins '(:in) :output-pins '(:out)))
        (cat (@new-code :input-handler #'cat :input-pins '(:in) :output-pins '(:out)))
        (wire-in (@new-wire))
        (wire-out (@new-wire))
        (char 'EOF))
    (@top-level-schematic top-level)
    (@add-part-to-schematic top-level cat)
    (@add-inbound-receiver-to-wire wire-in cat :in)
    (@add-outbound-receiver-to-wire wire-out cat :out)
    (@add-source-to-schematic top-level top-level :in wire-in)
    (@add-source-to-schematic top-level cat :out wire-out)

    (@:loop
     (setf char (read-char input-stream nil 'EOF))
     (@:exit-when (eq 'EOF char))
     (let ((result (cat char)))
       (format output-stream "~&~S" result)))))

(defun main ()
  (with-open-file (in (asdf:system-relative-pathname :cl "junk.json") :direction :input)
    (convert-JSON-to-Lisp-network in *standard-output*)))

(defun cat (lisp-obj)
  (format nil "count=~a code=0x~x char=~S" (length (string lisp-obj)) (char-code lisp-obj) lisp-obj))

