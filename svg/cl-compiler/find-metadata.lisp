
(in-package :arrowgrams/compiler/FIND-METADATA)

; (:code FIND-METADATA (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/FIND-METADATA::react #'arrowgrams/compiler/FIND-METADATA::first-time)

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
            (format nil "FIND-METADATA in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (find-metadata self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "FIND-METADATA in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod metadata-inside-bounding-box ((self e/part:part)
                                          bL bT bR bB
                                          tL tT tR tB
                                          l g r e n c result)

  (assert (and (numberp bL) (numberp bT) (numberp bR) (numberp bB) 
               (numberp tL) (numberp tT) (numberp tR) (numberp tB)))

  (if (and (<= bL tL bR)
           (<= bT tT tB))
      (values T l g r e n c result)
    (values nil l g r e n c result)))

(defmethod find-metadata ((self e/part:part))
  (let ((rule '(
                (:find-metadata (:? text-id))
                (:rect (:? box-id))
                (:bounding_box_left (:? box-id) (:? bL))
                (:bounding_box_top (:? box-id) (:? bT))
                (:bounding_box_right (:? box-id) (:? bR))
                (:bounding_box_bottom (:? box-id) (:? bB))
                (:bounding_box_left (:? text-id) (:? tL))
                (:bounding_box_top (:? text-id) (:? tT))
                (:bounding_box_right (:? text-id) (:? tR))
                (:bounding_box_bottom (:? text-id) (:? tB))
                (:lisp (metadata-inside-bounding-box
                        (:? bL) (:? bT) (:? bR) (:? bB)
                        (:? tL) (:? tT) (:? tR) (:? tB)))
                (:component (:? main-id))
                (:lisp (arrowgrams/compiler/util::asserta (:used (:? text-id))))
                (:lisp (arrowgrams/compiler/util::asserta (:roundedrect (:? box-id))))
                (:lisp (arrowgrams/compiler/util::retract (:rect (:? box-id))))
                (:lisp (arrowgrams/compiler/util::asserta (:parent (:? main-id) (:? box-id)))
                (:lisp (arrowgrams/compiler/util::asserta (:log (:? text-id) :is-meta-data)))
                ))))
    (let ((fb (cons rule (cl-event-passing-user::@get-instance-var self :fb))))
      (arrowgrams/compiler/util::run-prolog self '((:find-metadata (:? text-id))) fb))))