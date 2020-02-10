
(in-package :arrowgrams/compiler)
(defclass match-ports-to-components (e/part:part) ())
(defmethod e/part:busy-p ((self match-ports-to-components)) (call-next-method))

; (:code MATCH-PORTS-TO-COMPONENTS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self match-ports-to-components))
  (@set self :state :idle)
  (call-next-method))

(defmethod e/part:react ((self match-ports-to-components) e)
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
            (format nil "MATCH-PORTS-TO-COMPONENTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&match-ports-to-components~%")
             (match-ports-to-components self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "MATCH-PORTS-TO-COMPONENTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))
    (call-next-method)))

(defmethod match-ports-to-components ((self match-ports-to-components))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (arrowgrams/compiler/util::fb-keep '(:eltype :parent :ellipse :rect
                                               :bounding_box_left :bounding_box_top :bounding_box_right :bounding_box_bottom
                                               :wen :nle :we :nl :wspc) (@get self :fb))
                   #+nil(@get self :fb)
                   ))
        (goal '((:match_ports_to_components (:? A)))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))

