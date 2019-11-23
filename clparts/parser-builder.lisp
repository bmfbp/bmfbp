(in-package :arrowgrams)

(defun parser-builder (filename-string)
  #+nil(cl-event-passing-user::@enable-logging)
  (let ((net 
         (cl-event-passing-user::@defnetwork arrowgrams::main
             (:code readfile (:filename) (:out :fatal) #'readfileintostring)
             (:code pegp (:peg-in) (:lisp-list-out :fatal) #'pegtolisp)
             (:code stripq (:in) (:out :fatal) #'stripquotes)
             (:schem arrowgrams::main (:peg-source-file-name) (:lisp-source-out :fatal-error)
                ;; internal-parts
                (readfile pegp stripq)
                ;; wiring
                ((((:self :peg-source-file-name)) ((readfile :filename)))
                 (((readfile :out)) ((stripq :in)))
                 (((stripq :out)) ((pegp :peg-in)))
                 (((pegp :lisp-list-out)) ((:self :lisp-source-out)))
                 (((readfile :fatal) (pegp :fatal) (stripq :fatal)) ((:self :fatal-error)))
                 )))))
    (let ((ap e/dispatch::*all-parts*)) ;; testing only
      (assert (= 4 (length ap)))        ;; testing only
      (cl-event-passing-user::@inject net
               (e/part::get-input-pin net :peg-source-file-name)
               filename-string)
      (cl-event-passing-user::@history))))

(defun test ()
  (parser-builder (asdf:system-relative-pathname :arrowgrams/clparts "clparts/test.peg")))
