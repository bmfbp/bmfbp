
(in-package :arrowgrams/compiler)
(defclass add-kinds (e/part:part) ())
(defmethod e/part:busy-p ((self add-kinds)) (call-next-method))

; (:code ADD-KINDS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self add-kinds))
  (@set self :state :idle)
  (call-next-method))

(defmethod e/part:react ((self add-kinds) e)
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
            (format nil "ADD-KINDS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&add-kinds~%")
             (add-kinds self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "ADD-KINDS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))
    (call-next-method)))

(defmethod text-completely-inside-box ((self add-kinds) text-id tL tT box-id bL bT bR bB
                                       l g r e n c result)
  (declare (ignore self))
  ;; LT point completely inside bb
  (values (and (<= bL tL bR)
               (<= bT tT bB))
          l g r e n c result))

;;
;; used always refers to a text-id, e.g. text(text-id,str-id)

#+nil (defmethod old-add-kinds ((self add-kinds))
  (let ((add-kinds-rule '(
                          (:add-kinds (:? box-id))
                          (:rect (:? box-id))
                          (:bounding_box_left (:? box-id) (:? bL))
                          (:bounding_box_top (:? box-id) (:? bT))
                          (:bounding_box_right (:? box-id) (:? bR))
                          (:bounding_box_bottom (:? box-id) (:? bB))
                          (:text (:? text-id) (:? str-id))
                          (:bounding_box_left (:? text-id) (:? tL))
                          (:bounding_box_top (:? text-id) (:? tT))
                          (:not-used (:? text-id))
                          (:lisp (text-completely-inside-box (:? text-id) (:? tL) (:? tT)
                                                             (:? box-id) (:? bL) (:? bT) (:? bR) (:? bB)))
                          (:lisp (arrowgrams/compiler/util::asserta (:used (:? text-id))))
                          (:lisp (arrowgrams/compiler/util::asserta (:kind (:? box-id) (:? text-id))))
                          )
                        ))
    (let ((not-used-rule1 '(
                            (:not-used (:? text-id))
                            (:used (:? text-id))
                            :!
                            :fail)
                          )
          )
      (let ((not-used-rule2 '(
                              (:not-used (:? text-id))
                              )
                            ))
        (let ((fb (cons not-used-rule1 ;; order matters!
                        (cons not-used-rule2
                              (cons add-kinds-rule (@get self :fb))))))
          (arrowgrams/compiler/util::run-prolog self '((:add-kinds (:? box-id))) fb))))))
      

(defmethod add-kinds ((self add-kinds))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
       ;(goal '((:trace-on 1) (:add_kinds_main))))
        (goal '((:add_kinds_main))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))

#+nil (defmethod add-kinds ((self add-kinds))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (@get self :fb)))
        (goal '((:printall))))
    (arrowgrams/compiler/util::run-prolog self goal fb)))
