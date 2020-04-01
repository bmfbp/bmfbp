(in-package :cl-event-passing-user)

(defun test0 ()
  (@initialize)

  (let ((schem (@new-schematic :name "schem"))
        (producer (@new-code :name "producer" :output-pins '(:out)))
        (consumer (@new-code :name "consumer" :input-pins '(:in)))
        (wire (@new-wire :name "wire1")))

    (@top-level-schematic schem)

    (@add-part-to-schematic schem producer)
    (@add-part-to-schematic schem consumer)

    (@set-first-time-handler producer #'produce)
    (@set-input-handler consumer #'consume-and-print)

    (@add-receiver-to-wire wire (e/part::get-input-pin consumer :in))
    (@add-source-to-schematic schem (e/part::get-output-pin producer :out) wire)

    ;; don't do this - this was early testing, see test16.lisp for an example of how to do things
    (@start-dispatcher)))

(defmethod produce ((self e/part:part))
  (@send self (e/part::get-output-pin self :out) "hello"))

(defmethod consume-and-print ((self e/part:part) (e e/event:event))
  (format *standard-output* "~&consumed message ~S on incoming pin ~S of ~S~%"
          (e/event::data e) (e/pin:pin-name (e/event::event-pin e)) (e/part:name self)))

  
