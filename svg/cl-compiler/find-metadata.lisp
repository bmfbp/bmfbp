
(in-package :arrowgrams/compiler)
(defclass find-metadata (e/part:part) ())
(defmethod e/part:busy-p ((self find-metadata)) (call-next-method))

; (:code FIND-METADATA (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self find-metadata))
  (@set self :state :idle)
  (call-next-method))

(defmethod e/part:react ((self find-metadata) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (@get self :state)
      (:idle
       (if (eq pin :fb)
           (@set self :fb data)
         (if (eq pin :go)
             (progn
               (@send self :request-fb t)
               (@set self :state :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "FIND-METADATA in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&find-metadata~%")
             (find-metadata self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "FIND-METADATA in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))
    (call-next-method)))

#|

(defmethod metadata-inside-bounding-box ((self find-metadata)
                                          bID bL bT bR bB
                                          tID tL tT tR tB
                                          l g r e n c result)

  (assert (and (numberp bL) (numberp bT) (numberp bR) (numberp bB) 
               (numberp tL) (numberp tT) (numberp tR) (numberp tB)))

  ;; centerCompletelyInsideBoundingBox - text center inside bb of box
  (let ((cx (+ tL (- tR tL)))
        (cy (+ tT (- tB tT))))
    (if (and (<= bL cx bR)
             (<= bT cy bB))
        (values T l g r e n c result)
      (values nil l g r e n c result))))


(defmethod find-metadata ((self find-metadata))
  (let ((rule '(
                (:find-metadata (:? text-id))
                (:metadata (:? meta-id) (:? text-id))
                (:rect (:? box-id))
                (:bounding_box_left (:? box-id) (:? bL))
                (:bounding_box_top (:? box-id) (:? bT))
                (:bounding_box_right (:? box-id) (:? bR))
                (:bounding_box_bottom (:? box-id) (:? bB))
                (:bounding_box_left (:? text-id) (:? tL))
                (:bounding_box_top (:? text-id) (:? tT))
                (:bounding_box_right (:? text-id) (:? tR))
                (:bounding_box_bottom (:? text-id) (:? tB))
                (:lisp-method (metadata-inside-bounding-box
                        (:? box-id) (:? bL) (:? bT) (:? bR) (:? bB)
                        (:? text-id) (:? tL) (:? tT) (:? tR) (:? tB)))
                (:component (:? main-id))
                (:lisp-method (arrowgrams/compiler/util::retract (:rect (:? box-id))))
                (:lisp-method (arrowgrams/compiler/util::asserta (:used (:? text-id))))
                (:lisp-method (arrowgrams/compiler/util::asserta (:log (:? text-id) :is-metadata)))
                (:lisp-method (arrowgrams/compiler/util::asserta (:roundedrect (:? box-id))))
                (:lisp-method (arrowgrams/compiler/util::asserta (:parent (:? main-id) (:? box-id)))))))
    (let ((fb (cons rule (@get self :fb))))
      (arrowgrams/compiler/util::run-prolog self '((:find-metadata (:? text-id))) fb))))

|#

(defmethod find-metadata ((self find-metadata))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:find_metadata_main))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))

