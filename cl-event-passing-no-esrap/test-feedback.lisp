(in-package :cl-event-passing-user)

(defun test-feedback()
  (let ((net 
         (cl-event-passing-user::@defnetwork cl-event-passing-user::main
          (:code filestream (:file-name :read :close) (:stream :object :done :fatal)
           #'filestream #'filestream-reset)
          (:code iter (:begin :next :finish) (:next :fatal) #'iter #'iter-reset)
          (:code cat (:in) (:out :fatal) #'cat)
          (:code fatal (:in) () #'fatal)
          (:schem cl-event-passing-user::main (:in) (:out)
                 (filestream cat fatal iter)
                 ((((:self :in))  ((filestream :file-name)))
                  (((iter :next)) ((filestream :read)))
                  (((filestream :stream)) ((iter :begin)))
                  (((filestream :object)) ((iter :next) (cat :in)))
                  (((filestream :done)) ((iter :finish)(filestream :close))) ;; feedback is here
                  (((cat :out)) ((:self :out)))
                  (((filestream :fatal) (iter :fatal) (cat :fatal)) ((fatal :in))))))))
    (let ((ap e/dispatch::*all-parts*)) ;; testing only
      (assert (= 5 (length ap)))        ;; testing only
      (@with-dispatch
       (@inject net
                (e/part::get-input-pin net :in) (asdf:system-relative-pathname :cl-event-passing "test-feedback.lisp"))
      (@history)))))

