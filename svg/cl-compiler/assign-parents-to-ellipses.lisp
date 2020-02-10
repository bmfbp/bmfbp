(in-package :arrowgrams/compiler)

(defclass assign-parents-to-ellipses (e/part:part) ())
(defmethod e/part:busy-p ((self assign-parents-to-ellipses)) (call-next-method))
; (:code assign-parents-to-ellipses (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self assign-parents-to-ellipses))
  (@set self :state :idle)
  (call-next-method))

(defmethod e/part:react ((self assign-parents-to-ellipses) e)
  (let ((pin (@pin e))
        (data (@data e)))
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
            (format nil "ASSIGN PARENTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&assign-parents-to-ellipses~%")
             (assign-parents self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "ASSIGN PARENTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e)))))))
  (call-next-method))

(defmethod assign-parents ((self assign-parents-to-ellipses))
  (let ((rule '(
                (:make-parent-for-ellipse (:? id) (:? main))
                (:ellipse (:? id))
                (:component (:? main))
                (:lisp-method (arrowgrams/compiler/util::asserta (:parent (:? main) (:? id))))
                )))
    (let ((fb (cons rule (@get self :fb))))
      (hprolog:prove nil '((:make-parent-for-ellipse (:? eid) (:? main-id))) fb hprolog:*empty* 1 nil fb nil self))))
