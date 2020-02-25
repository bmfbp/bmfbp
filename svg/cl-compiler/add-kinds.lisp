
(in-package :arrowgrams/compiler)
(defclass add-kinds (compiler-part) ())
(defmethod e/part:busy-p ((self add-kinds)) (call-next-method))
(defmethod e/part:clone ((self add-kinds)) (call-next-method))

; (:code ADD-KINDS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self add-kinds))
  (call-next-method))

(defmethod e/part:react ((self add-kinds) e)
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
            (format nil "ADD-KINDS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (format *standard-output* "~&add-kinds~%")
             (add-kinds self)
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "ADD-KINDS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod text-completely-inside-box ((self add-kinds) text-id tL tT box-id bL bT bR bB
                                       l g r e n c result)
  (declare (ignore self))
  ;; LT point completely inside bb
  (values (and (<= bL tL bR)
               (<= bT tT bB))
          l g r e n c result))

;;
;; used always refers to a text-id, e.g. text(text-id,str-id)

(defmethod add-kinds ((self add-kinds))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (fb self)))
       ;(goal '((:trace-on 1) (:add_kinds_main))))
        (goal '((:add_kinds_main))))
    (run-prolog self goal fb)))

