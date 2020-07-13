(in-package :cl-event-passing-user)

(defun test1 ()
  (@initialize)

  (let ((schem (@new-schematic :name "schem" :output-pins '(:schem-out)))
        (producer (@new-code :name "producer" :output-pins '(:producer-out)))
        (wire99 (@new-wire :name "wire99")))

    (@top-level-schematic schem)

    (@add-part-to-schematic schem producer)

    (@set-first-time-handler producer #'test1-produce-first-time)

    (@add-receiver-to-wire wire99 (e/part::get-output-pin schem :schem-out))
    (let ((pin (e/part::get-output-pin producer :producer-out)))
      (@add-source-to-schematic schem pin wire99))

    (setf cl-event-passing-user::*test1-net* schem)  ;; save net for reuse in test-reuse1.lisp

    (@start-dispatcher)))

(defmethod test1-produce-first-time ((self e/part:part))
  (@send self (e/part::get-output-pin self :producer-out) "hello from test 1"))

  
