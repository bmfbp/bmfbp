(in-package :arrowgrams/compiler)

(defclass sequencer (e/part:part) ())
(defmethod e/part:busy-p ((self sequencer)) (call-next-method))
; (:code sequencer (:finished-reading :finished-pipeline :finished-writing) (:poke-fb :run-pipeline :write :error))

;; read a string fact, output as a lisp fact with all symbols converted to keywords

(defmethod e/part:first-time ((self sequencer))
  (@set self :state :idle))

(defmethod e/part:react ((self sequencer) e)
  (let ((pin (@pin self e))
        (string-fact (@data self e))
        (new-list nil))
    (ecase (@get self :state)
      (:idle
       (if (eq pin :finished-reading)
           (progn
             (@send self :poke-fb t)
             (@send self :run-pipeline t)
             ;(@send self :show t)
             (@set self :state :waiting-for-pipeline))
         (@send
          self
          :error
          (format nil "SEQUENCER in state :idle expected :finished-reading, but got action ~S data ~S" pin (@data self e)))))
      
         (:waiting-for-pipeline
          (if (eq pin :finished-pipeline)
              (progn
                (@send self :write t)
                (@set self :state :waiting-for-write))
            (@send
             self
             :error
             (format nil "SEQUENCER in state :waiting-for-pipeline expected :finished-pipeline, but got action ~S data ~S" pin (@data self e)))))

         (:waiting-for-write
          (if (eq pin :finished-writing)
              (progn
                (@set self :state :idle))
            (@send
             self
             :error
             (format nil "SEQUENCER in state :waiting-for-write expected :finished-writing, but got action ~S data ~S" pin (@data self e)))))
         
         )))
