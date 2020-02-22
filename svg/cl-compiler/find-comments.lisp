(in-package :arrowgrams/compiler)
(defclass find-comments (e/part:code) ())
(defmethod e/part:busy-p ((self find-comments)) (call-next-method))
(defmethod e/part:clone ((self find-comments)) (call-next-method))

; (:code FIND-COMMENTS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self find-comments))
  (@set self :state :idle))

(defmethod e/part:react ((self find-comments) e)
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
            (format nil "FIND-COMMENTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&find-comments~%")
             (find-comments self)
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "FIND-COMMENTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod find-comments ((self find-comments))
  (let ((text-bbs (arrowgrams/compiler/util::find-all-text self)))
    (let ((speechbubble-bbs (arrowgrams/compiler/util::find-all-speechbubbles self)))
      (dolist (sbb speechbubble-bbs)
        (find-first-containment-and-create-new-facts self sbb text-bbs)))))

(defmethod find-first-containment-and-create-new-facts ((self find-comments) speechbubble-bb text-bbs)
  (arrowgrams/compiler/classes::with-speechbubble-bb (left top right bottom) speechbubble-bb
     (dolist (text-bb text-bbs)
       (arrowgrams/compiler/classes::with-text-bb (text-id text-left text-top text-right text-bottom) text-bb
          (when (arrowgrams/compiler/util::bb-contains left top right bottom text-left tex-top text-right text-bottom)
            (let ((textid (cdr (first text-bb))))
              (@send self :add-fact (list :used textid))
              (format *standard-output* "~&add fact ~S~%" (list :used textid))
              (@send self :add-fact (list :comment textid))
              (format *standard-output* "~&add fact ~S~%" (list :comment textid))
              (return-from find-first-containment-and-create-new-facts nil))))
       (assert nil)))) ;; can't happen

