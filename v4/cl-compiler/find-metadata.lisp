
(in-package :arrowgrams/compiler)
(defclass find-metadata (compiler-part) ())
(defmethod e/part:busy-p ((self find-metadata)) (call-next-method))
(defmethod e/part:clone ((self find-metadata)) (call-next-method))

; (:code FIND-METADATA (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self find-metadata))
  (call-next-method))

(defmethod e/part:react ((self find-metadata) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (state self)
      (:idle
       (if (eq pin :fb)
           (setf (fb self) data)
         (if (eq pin :go)
             (progn
               (@send self :request-fb t)
               (setf (state self) :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "FIND-METADATA in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (find-metadata self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "FIND-METADATA in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod find-metadata ((self find-metadata))
  (let ((fb (append *rules* (fb self)))
        (goal '((:find_metadata_main))))
    (run-prolog self goal fb)))

