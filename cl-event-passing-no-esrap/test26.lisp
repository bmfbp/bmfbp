(in-package :cl-event-passing-user)

(defun test26() ;; same as test6, but uses macro
  (let ((net 
         (cl-event-passing-user::@defnetwork cl-event-passing-user::main
          (:code flowThrough1 (:ftin) (:ftout) #'flow-through26)
          (:code flowThrough2 (:ftin) (:ftout) #'flow-through26)
          (:schem child (:childin) (:childout)
                 (flowThrough1 flowThrough2)
                 "
                 self.childin -> flowThrough1.ftin
                 flowThrough1.ftout -> flowThrough2.ftin
                 flowThrough2.ftout -> self.childout
                 "
          )
          (:schem cl-event-passing-user::main (:in) (:out)
                 (child)
                  "
                  self.in -> child.childin
                  child.childout -> self.out
                  "
                  ))))
  (let ((ap e/dispatch::*all-parts*))  ;; testing only
    (assert (= 4 (length ap)))         ;; testing only
    (@with-dispatch
     (@inject net
              (e/part::get-input-pin net :in) "test 26")))))

(defmethod flow-through26 ((self e/part:part) (e e/event:event))
  (@send self (e/part::get-output-pin self :ftout) (e/event:data e)))

