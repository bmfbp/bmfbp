(in-package :arrowgrams/compiler)

(defclass assign-parents-to-ellipses (compiler-part) ())
(defmethod e/part:busy-p ((self assign-parents-to-ellipses)) (call-next-method))
(defmethod e/part:clone ((self assign-parents-to-ellipses)) (call-next-method))
; (:code assign-parents-to-ellipses (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self assign-parents-to-ellipses))
  (call-next-method))

(defmethod e/part:react ((self assign-parents-to-ellipses) e)
  (let ((pin (@pin self e))
        (data (@data self e)))
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
            (format nil "ASSIGN PARENTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (assign-parents self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "ASSIGN PARENTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod assign-parents ((self assign-parents-to-ellipses))
  (let ((rule '(
                (:make-parent-for-ellipse (:? id) (:? main))
                (:ellipse (:? id))
                (:component (:? main))
                (:lisp-method (asserta (:parent (:? main) (:? id))))
                )))
    (let ((fb (cons rule (fb self))))
      (hprolog:prove nil '((:make-parent-for-ellipse (:? eid) (:? main-id))) fb hprolog:*empty* 1 nil fb nil self))))
