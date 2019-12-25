
(in-package :arrowgrams/compiler/ADD-SELF-PORTS)

; (:code ADD-SELF-PORTS (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/ADD-SELF-PORTS::react #'arrowgrams/compiler/ADD-SELF-PORTS::first-time)

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
            (format nil "ADD-SELF-PORTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (format *standard-output* "~&add-self-ports~%")
             (create-self-ports self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "ADD-SELF-PORTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))


(defmethod port-touches-ellipse ((self e/part:part)
                                 pL pT pR pB
                                 eL eT eR eB
                                 l g r e n c result)
  (values
   (or (and (<= pL eL)
            (>= pR eL)
            (>= pT eT)
            (<= pR eR))
       (and (<= pT eT)
            (>= pB eT)
            (>= pL eL)
            (<= pR eR))
       (and (<= pL eR)
            (>= pR eR)
            (>= pT eT)
            (<= pB eB))
       (and (<= pT eB)
            (>= pB eB)
            (>= pL eL)
            (<= pR eR)))
   l g r e n c result))
                                 

(defmethod create-self-ports ((self e/part:part))
  ;;;     % find one port that touches the ellispe (if there are more, then the "coincidentPorts"
  ;;;     % pass will find them), asserta all facts needed by ports downstream - portIndex, sink,
  ;;;     % source, parent
    (let ((goal '(
                  (:port (:? port-id))
(:lisp (arrowgrams/compiler/util::printf 1))
                  (:bounding-box (:? port-id) (:? pL) (:? pT) (:? pR) (:? pB))
(:lisp (arrowgrams/compiler/util::printf 2))
                  (:ellipse (:? eid))
                  (:bounding-box (:? eid) (:? eL) (:? eT) (:? eR) (:? eB))
                  (:lisp (port-touches-ellipse (:? pL) (:? pT) (:? pR) (:? pB) (:? eL) (:? eT) (:? eR) (:? eB)))
                  (:text (:? text-id) (:? str))
(:lisp (arrowgrams/compiler/util::printf 6))
                  (:text-completely-inside (:? text-id) (:? eid))
(:lisp (arrowgrams/compiler/util::printf 7))
                  :!
                  (:lisp (asserta (:parent (:? eid) (:? port-id))))
                  (:lisp (asserta (:used (:? text-id))))
                  (:lisp (asserta (:portNameByID (:? port-id) (:? text-id))))
                  (:lisp (asserta (:portName (:? port-id) (:? str))))
                  )))
      (let ((fb (arrowgrams/compiler/util::rule-text-completely-inside)))
        (arrowgrams/compiler/util::run-prolog self goal fb))))
