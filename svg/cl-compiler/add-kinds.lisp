
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

(defmethod text-completely-inside-box ((self e/part:part) text-id tL tT box-id bL bT bR bB
                                       l g r e n c result)
  (declare (ignore self))
  ;; LT point completely inside bb
  (values (and (<= bL tL bR)
               (<= bT tT bB))
          l g r e n c result))

;;
;; used always refers to a text-id, e.g. text(text-id,str-id)

(defmethod old-add-kinds ((self e/part:part))
  (let ((add-kinds-rule '(
                          (:add-kinds (:? box-id))
                          (:rect (:? box-id))
                          (:bounding_box_left (:? box-id) (:? bL))
                          (:bounding_box_top (:? box-id) (:? bT))
                          (:bounding_box_right (:? box-id) (:? bR))
                          (:bounding_box_bottom (:? box-id) (:? bB))
                          (:text (:? text-id) (:? str-id))
                          (:bounding_box_left (:? text-id) (:? tL))
                          (:bounding_box_top (:? text-id) (:? tT))
                          (:not-used (:? text-id))
                          (:lisp (text-completely-inside-box (:? text-id) (:? tL) (:? tT)
                                                             (:? box-id) (:? bL) (:? bT) (:? bR) (:? bB)))
                          (:lisp (arrowgrams/compiler/util::asserta (:used (:? text-id))))
                          (:lisp (arrowgrams/compiler/util::asserta (:kind (:? box-id) (:? text-id))))
                          )
                        ))
    (let ((not-used-rule1 '(
                            (:not-used (:? text-id))
                            (:used (:? text-id))
                            :!
                            :fail)
                          )
          )
      (let ((not-used-rule2 '(
                              (:not-used (:? text-id))
                              )
                            ))
        (let ((fb (cons not-used-rule1 ;; order matters!
                        (cons not-used-rule2
                              (cons add-kinds-rule (cl-event-passing-user::@get-instance-var self :fb))))))
          (arrowgrams/compiler/util::run-prolog self '((:add-kinds (:? box-id))) fb))))))
      

(defmethod add-kinds ((self e/part:part))
  (let ((fb
         (cons arrowgrams/compiler::+rules+
               (cl-event-passing-user::@get-instance-var self :fb)))
        (goal '((:add_kinds_main))))
          (arrowgrams/compiler/util::run-prolog self goal fb)))
