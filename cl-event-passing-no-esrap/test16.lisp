(in-package :cl-event-passing-user)

(defun test16() ;; same as test6, but uses macro
  (let ((net 
         (cl-event-passing-user::@defnetwork cl-event-passing-user::main
          (:code flow-through-1 (:ftin) (:ftout) #'flow-through16)
          (:code flow-through-2 (:ftin) (:ftout) #'flow-through16)
          (:schem child (:childin) (:childout)
                 (flow-through-1 flow-through-2)
                 (
                  (((:self :childin)) ((flow-through-1 :ftin)))
                  (((flow-through-1 :ftout)) ((flow-through-2 :ftin)))
                  (((flow-through-2 :ftout)) ((:self :childout)))
                  ))
          (:schem cl-event-passing-user::main (:in) (:out)
                 (child)
                 ((((:self :in)) ((child :childin)))
                  (((child :childout)) ((:self :out))))))))
  (let ((ap e/dispatch::*all-parts*))  ;; testing only
    (assert (= 4 (length ap)))         ;; testing only
    (@with-dispatch
     (@inject net
              (e/part::get-input-pin net :in) "test 16")))))

(defmethod flow-through16 ((self e/part:part) (e e/event:event))
  (@send self (e/part::get-output-pin self :ftout) (e/event:data e)))

