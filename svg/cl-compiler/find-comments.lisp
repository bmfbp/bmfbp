
(in-package :arrowgrams/compiler/FIND-COMMENTS)

; (:code FIND-COMMENTS (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/FIND-COMMENTS::react #'arrowgrams/compiler/FIND-COMMENTS::first-time)

(defmethod first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  )

(defmethod react ((self e/part:part) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (cl-event-passing-user::@get-instance-var self :state)
      (:idle
       (if (eq pin :fb)
           (cl-event-passing-user::@set-instance-var self :fb data)
         (if (eq pin :go)
             (progn
               (cl-event-passing-user::@send self :request-fb t)
               (cl-event-passing-user::@set-instance-var self :state :waiting-for-new-fb))
           (cl-event-passing-user::@send
            self
            :error
            (format nil "FIND-COMMENTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (format *standard-output* "~&find-comments~%")
             (find-comments self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "FIND-COMMENTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))


(defmethod find-comments ((self e/part:part))
  (let ((text-bbs (arrowgrams/compiler/util::find-all-text self)))
    (let ((speechbubble-bbs (arrowgrams/compiler/util::find-all-speechbubbles self)))
      (dolist (sbb speechbubble-bbs)
        (find-first-containment-and-create-new-facts self sbb text-bbs)))))

(defmethod find-first-containment-and-create-new-facts ((self e/part:part) speechbubble-bb text-bbs)
  (arrowgrams/compiler/classes::with-speechbubble-bb (left top right bottom) speechbubble-bb
     (dolist (text-bb text-bbs)
       (arrowgrams/compiler/classes::with-text-bb (text-id text-left text-top text-right text-bottom) text-bb
          (when (arrowgrams/compiler/util::bb-contains left top right bottom text-left tex-top text-right text-bottom)
            (let ((textid (cdr (first text-bb))))
              (cl-event-passing-user::@send self :add-fact (list :used textid))
              (format *standard-output* "~&add fact ~S~%" (list :used textid))
              (cl-event-passing-user::@send self :add-fact (list :comment textid))
              (format *standard-output* "~&add fact ~S~%" (list :comment textid))
              (return-from find-first-containment-and-create-new-facts nil))))
       (assert nil)))) ;; can't happen

