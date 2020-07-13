(in-package :cl-event-passing-user)

(defun test-reuse3 ()
  (@initialize)

  (let ((net 
         (cl-event-passing-user::@defnetwork cl-event-passing-user::main
          (:part cl-event-passing-user::*test1-net* child nil (:schem-out))
          (:schem cl-event-passing-user::main (:main-in) (:main-out)
                 (child)
                 ((((child :schem-out)) ((:self :main-out))))))))

    (@start-dispatcher)))
  
