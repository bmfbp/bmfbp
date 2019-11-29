(in-package :arrowgrams/clparts)

(defun test ()
  (cl-event-passing-user::@enable-logging)
  (let ((net (parser-builder)))
    (let ((ap e/dispatch::*all-parts*)) ;; testing only
      (assert (= 4 (length ap)))        ;; testing only
      (cl-event-passing-user::@send
       net
       (e/part::get-input-pin net :peg-source-file-name)
       (asdf:system-relative-pathname :arrowgrams/clparts "clparts/test.peg"))
      (cl-event-passing-user::@history))
    (setf arrowgrams/clparts::*parser-builder-net* net)))

(defun test-macro ()
  (cl-event-passing-user::@enable-logging)
  (let ((net
         (cl-event-passing-user::@defnetwork 
          XXX ;; TODO: is this ALWAYS the same as the last declaration?
          (:part (parser-builder) pbuilder (:peg-source-file-name) (:lisp-source-out :fatal-error))
          (:schem XXX (:peg-source-file-name) (:lisp-source-out)
           (pbuilder) ;; internal parts
           ;; wiring
           ((((:self :peg-source-file-name)) ((pbuilder :peg-source-file-name)))
            (((pbuilder :lisp-souce-out)) ((:self :lisp-source-out))))))))
    (let ((peg-filename (asdf:system-relative-pathname :arrowgrams/clparts "clparts/test.peg"))
          (in-pin (e/part::get-input-pin net :peg-source-file-name)))
      (cl-event-passing-user::@send net in-pin peg-filename))))

(defun arrowgrams/clparts::test-all ()
  (format *standard-output* "~&running test~%")
  (test)
  (format *standard-output* "~&running test-macro~%")
  (test-macro)
  (cl-event-passing-user::@history))

      
     