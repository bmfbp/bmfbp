(in-package :cl-event-passing-user)

(defun test-reuse4 ()
  (@initialize)

  (let ((net 
         (cl-event-passing-user::@defnetwork cl-event-passing-user::main
          (:part cl-event-passing-user::*test6-net* child (:main-schem-in) (:main-schem-out))
          (:schem cl-event-passing-user::main (:main-in) (:main-out)
                 (child)
                 ((((child :main-schem-out)) ((:self :main-out)))
                  (((:self :main-in)) ((child :main-schem-in))))))))
    
    (@with-dispatch
     (@inject net (e/part::get-input-pin net :main-in) " testing reuse of part test6 (test-reuse4) "))))

(defun cl-user::rtest()
  ;; convenience function - to be deleted
  (cl-event-passing-user::test6)
  (format *standard-output* "~&about to run test-reuse4~%")
  (test-reuse4))

