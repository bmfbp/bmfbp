
(in-package :arrowgrams/compiler)
(defclass find-metadata (e/part:part) ())
(defmethod e/part:busy-p ((self find-metadata)) (call-next-method))

; (:code FIND-METADATA (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self find-metadata))
  (@set self :state :idle))

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
          (format nil "FIND-METADATA in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod find-metadata ((self find-metadata))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:find_metadata_main))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))

