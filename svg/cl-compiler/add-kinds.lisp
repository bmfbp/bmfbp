
(in-package :arrowgrams/compiler/ADD-KINDS)

; (:code ADD-KINDS (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/ADD-KINDS::react #'arrowgrams/compiler/ADD-KINDS::first-time)

(defmethod first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  )

(defmethod react ((self e/part:part) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (cl-event-passing-user::@get-instance-var self :state)
      (:idle
       (if (eq pin :fb)
           (cl-event-passing-user::@set-instance-var self :fb data)
         (if (eq pin :go)
             (progn
               (cl-event-passing-user::@send self :request-fb t)
               (cl-event-passing-user::@set-instance-var self :state :waiting-for-new-fb))
           (cl-event-passing-user::@send
            self
            :error
            (format nil "ADD-KINDS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (format *standard-output* "~&add-kinds~%")
             (add-kinds self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "ADD-KINDS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod text-completely-inside-box ((self e/part:part) text-id tL tT box-id bL bT bR bB)
  ;; LT point completely inside bb
  (and (<= bL tL bR)
       (<= bT tT bB)))

(defmethod add-kinds ((self e/part:part))
  (let ((rule '(
                (:add-kinds (:? box-id))
                (:rect (:? box-id))
(:lisp (arrowgrams/compiler/util::printf (:? box-id)))
                (:text (:? text-id) (:? str-id))
(:lisp (arrowgrams/compiler/util::printf 2))
                (:not-used (:? str-id))
(:lisp (arrowgrams/compiler/util::printf 3))
                (:bounding_box_left (:? text-id) (:? tL))
(:lisp (arrowgrams/compiler/util::printf 4))
                (:bounding_box_left (:? text-id) (:? tT))
(:lisp (arrowgrams/compiler/util::printf 5))
                (:rect (:? box-id))
(:lisp (arrowgrams/compiler/util::printf 6))
                (:bounding_box_left (:? box-id) (:? bL))
(:lisp (arrowgrams/compiler/util::printf 7))
                (:bounding_box_top (:? box-id) (:? bT))
(:lisp (arrowgrams/compiler/util::printf 8))
                (:bounding_box_right (:? box-id) (:? bR))
(:lisp (arrowgrams/compiler/util::printf 9))
                (:bounding_box_bottom (:? box-id) (:? bB))
(:lisp (arrowgrams/compiler/util::printf 10))
                (:lisp (text-completely-inside-box (:? text-id) (:? tL) (:? tB)
                                                   (:? box-id) (:? bL) (:? bT) (:? bR) (:? bB)))
                (:lisp (arrowgrams/compiler/util::asserta (:used (:? text-id))))
                (:lisp (arrowgrams/compiler/util::asserta (:kind (:? box-id) (:? text-id))))
                ((:not-used (:? str-id))
(:lisp (arrowgrams/compiler/util::printf 2a))
                 (:used (:? str-id))
(:lisp (arrowgrams/compiler/util::printf 2b))
                 :!
(:lisp (arrowgrams/compiler/util::printf 2c))
                 :fail)
                ((:not-used (:? str-id)))
                )))
    (let ((fb (cons rule (cl-event-passing-user::@get-instance-var self :fb))))
      (arrowgrams/compiler/util::run-prolog self '((:add-kinds (:? box-id))) fb))))