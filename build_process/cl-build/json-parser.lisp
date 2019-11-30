(in-package :arrowgrams/build/cl-build)

(defun json-parser ()
  ;; the only difference from above it "(parser-builder)" instead of "*parser-builder-net*"
  (let ((parser-builder-net (parser-builder))) ;; this call add parts to the dispatcher list
    (cl-event-passing-user::@initialize)       ;; this clears the dispatcher list
    (cl-event-passing-user::@enable-logging)
    (let ((net
           (cl-event-passing-user::@defnetwork 
            TOP
            (:part parser-builder-net pbuilder (:peg-source-file-name) (:lisp-source-out :fatal-error))
            (:code json-parser (:source-to-be-parsed :lisp-parser-source) (:lisp-source-out :fatal))
            (:schem TOP (:peg-source-file-name :json-source-file-name) (:lisp-source-out :fatal-error)
             (pbuilder json-parser) ;; internal parts
             ;; wiring
             ((((:self :peg-source-file-name)) ((pbuilder :peg-source-file-name)))
              (((:self :json-source-file-name)) ((json-parser :source-to-be-parsed)))
              (((pbuilder :lisp-source-out)) ((json-parser :lisp-parser-source)))
              
              (((json-parser :lisp-source-out)) ((:self :lisp-source-out)))

              (((json-parser :fatal)) ((:self :fatal-error)))
              (((pbuilder :fatal-error)) ((:self :fatal-error)))

      (e/dispatch::ensure-correct-number-of-parts (+ 2 4))
      (let ((peg-filename (asdf:system-relative-pathname :arrowgrams/builder/cl-build "test.peg"))
            (json-filename (asdf:system-relative-pathname :arrowgrams/builder/cl-build "test.json"))
            (peg-in-pin (e/part::get-input-pin net :peg-source-file-name))
            (json-in-pin (e/part::get-input-pin net :json-source-file-name)))
        (cl-event-passing-user::@send net peg-in-pin peg-filename))
        (cl-event-passing-user::@send net json-in-pin peg-filename)))))))))
  

      
     