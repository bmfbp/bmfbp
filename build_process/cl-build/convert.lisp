(in-package :cl-build)

(defun convert-JSON-to-Lisp-network (input-stream output-stream)
  (cl-event-passing-user::@initialize)
  (let ((net
         (cl-event-passing-user::@defnetwork main
              (:part 



  (let ((top-level (cl-event-passing-user:@new-schematic :input-pins '(:in) :output-pins '(:out)))
        (cat (cl-event-passing-user:@new-code :input-handler #'cat :input-pins '(:in) :output-pins '(:out)))
        (wire-in (cl-event-passing-user:@new-wire))
        (wire-out (cl-event-passing-user:@new-wire))
        (char 'EOF))
    (cl-event-passing-user:@top-level-schematic top-level)
    (cl-event-passing-user:@add-part-to-schematic top-level cat)
    (cl-event-passing-user:@add-inbound-receiver-to-wire wire-in cat :in)
    (cl-event-passing-user:@add-outbound-receiver-to-wire wire-out top-level :out)
    (cl-event-passing-user:@add-source-to-schematic top-level top-level :in wire-in)
    (cl-event-passing-user:@add-source-to-schematic top-level cat :out wire-out)

    (@:loop
     (setf char (read-char input-stream nil 'EOF))
     (@:exit-when (eq 'EOF char))
     (cl-event-passing-user:@inject top-level :in char))))

(defun main ()
  (with-open-file (in (asdf:system-relative-pathname :cl-build "junk.json") :direction :input)
    (convert-JSON-to-Lisp-network in *standard-output*)))

(defmethod cat ((self e/part:part) (e e/event:event))
  (let ((lisp-obj (e/event:data e)))
    (let ((new-e (cl-event-passing-user:@new-event
                  :pin :out
                  :data (format nil "count=~a code=0x~x char=~S" (length (string lisp-obj)) (char-code lisp-obj) lisp-obj))))
      (cl-event-passing-user:@send self new-e))))