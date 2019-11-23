(in-package :arrowgrams)

(defun test ()
  #+nil(cl-event-passing-user::@enable-logging)
  (let ((net (parser-builder)))
    (let ((ap e/dispatch::*all-parts*)) ;; testing only
      (assert (= 4 (length ap)))        ;; testing only
      (cl-event-passing-user::@inject
       net
       (e/part::get-input-pin net :peg-source-file-name)
       (asdf:system-relative-pathname :arrowgrams/clparts "clparts/test.peg"))
      (cl-event-passing-user::@history))))

