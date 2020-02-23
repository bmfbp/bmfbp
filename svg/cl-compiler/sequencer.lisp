(in-package :arrowgrams/compiler)

(defclass sequencer (e/part:code)
  ((prolog-output-filename :accessor prolog-output-filename)))

(defmethod e/part:busy-p ((self sequencer)) (call-next-method))
(defmethod e/part:clone ((self sequencer)) (call-next-method))
; (:code sequencer (:finished-reading :finished-pipeline :finished-writing :prolog-output-filename)
;     (:write-to-filename :poke-fb :run-pipeline :write :error))

;; read a string fact, output as a lisp fact with all symbols converted to keywords

(defmethod e/part:first-time ((self sequencer))
  (setf (prolog-output-filename self) nil)
  (@set self :state :idle))

(defmethod e/part:react ((self sequencer) e)
  (let ((pin (@pin self e))
        (string-fact (@data self e))
        (new-list nil))
    (ecase (@get self :state)
      (:idle
       (cond ((eq pin :finished-reading)
              (@send self :poke-fb t)
              (@send self :run-pipeline t)
             ;(@send self :show t)
              (@set self :state :waiting-for-pipeline))
             ((eq pin :prolog-output-filename)
              (@send self :write-to-filename (@data self e))
              (setf (prolog-output-filename self) (@data self e)))
             (t
              (@send
               self
               :error
               (format nil "SEQUENCER in state :idle expected :finished-reading, but got action ~S data ~S" pin (@data self e))))))
       
         (:waiting-for-pipeline
          (if (eq pin :finished-pipeline)
              (if (writing-p self)
                  (progn
                    (@send self :write t)
                    (@set self :state :waiting-for-write))
                (@set self :state :idle))
            (@send
             self
             :error
             (format nil "SEQUENCER in state :waiting-for-pipeline expected :finished-pipeline, but got action ~S data ~S" pin (@data self e)))))

         (:waiting-for-write
          (if (eq pin :finished-writing)
              (@set self :state :idle)
            (@send
             self
             :error
             (format nil "SEQUENCER in state :waiting-for-write expected :finished-writing, but got action ~S data ~S" pin (@data self e)))))
         
         )))

(defmethod writing-p ((self sequencer))
  (prolog-output-filename self))
