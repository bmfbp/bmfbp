(in-package :arrowgrams/compiler/emitter)

; (:code EMITTER (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/EMITTER::react #'arrowgrams/compiler/EMITTER::first-time)

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
            (format nil "EMITTER in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (format *standard-output* "~&emitter~%")
             (emitter self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "EMITTER in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod emitter ((self e/part:part))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (cl-event-passing-user::@get-instance-var self :fb))))
    (let ((goal '((:match_top_name (:? N)))))
      (let ((result (arrowgrams/compiler/util::run-prolog self goal fb)))
        (assert (and (listp result) (= 1 (length (car result)))))
        (let ((top-name (cdr (assoc 'N (car result)))))
          (format *standard-output* "~&name = ~A~%" top-name))))
    
    (let ((goal '((:find_parts (:? ID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((id (cdr (assoc 'ID result)))
                (strid (cdr (assoc 'Strid result))))
            (format *standard-output* "~&id = ~A strid=~a~%" id strid)))))

    (let ((goal '((:find_self_input_pins (:? PortID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((id (cdr (assoc 'ID result)))
                (strid (cdr (assoc 'Strid result))))
            (format *standard-output* "~&self input pin=~a~%" id strid)))))

    (let ((goal '((:find_self_output_pins (:? PortID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((id (cdr (assoc 'ID result)))
                (strid (cdr (assoc 'Strid result))))
            (format *standard-output* "~&self output pin=~a~%" id strid)))))))

