
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
             ;; put code here
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "ADD-SELF-PORTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))


(defmethod port-touches-ellipse ((self p/part:part)
                                 pL pT pR pB
                                 eL eT eR eB
                                 l g r e n c result)
  (values
<<<<<<< HEAD
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
   l g r e n d result))
                                 




=======
   (or
    (and (<= pL eL)
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
   l g r e n d result))
                                 

>>>>>>> pt-20191224-editor
(defmethod add-kinds ((self e/part:part))
  (let ((add-kinds-rule '((:add-self-ports (:? port-id))
                          
                          (:port (:? port-id))
<<<<<<< HEAD
                          (:bounding_box_left (:? port-id) (:? pL))
                          (:bounding_box_top (:? port-id) (:? pT))
                          (:bounding_box_right (:? port-id) (:? pR))
                          (:bounding_box_bottom (:? port-id) (:? pB))

                          (:ellipse (:? ellipse-id))
                          (:bounding_box_left (:? ellipse-id) (:? eL))
                          (:bounding_box_top (:? ellipse-id) (:? eT))
                          (:bounding_box_right (:? ellipse-id) (:? eR))
                          (:bounding_box_bottom (:? ellipse-id) (:? eB))
=======
                          (:bounding-box (:? port-id) (:? pL) (:? pT) (:? pR) (:? pB))
                          
                          (:ellipse (:? ellipse-id))
                          (:bounding-box (:? ellipse-id) (:? eL) (:? eT) (:? eR) (:? eB))
>>>>>>> pt-20191224-editor

                          (:lisp (port-touches-ellipse pL pT pR pB eL eT eR eB))

                          (:text (:? text-id) (:? str-id))

                          (:lisp (text-completely-inside (:? text-id) (:? ellipse-id)))

                          :!
                          (:lisp (arrowgrams/compiler/util::asserta (:parent (:? ellipse-id) (:? port-id))))
                          (:lisp (arrowgrams/compiler/util::asserta (:used (:? text-id))))
                          (:lisp (arrowgrams/compiler/util::asserta (:portNameByID (:? port-id) (:? text-id))))
                          (:lisp (arrowgrams/compiler/util::asserta (:portName (:? port-id) (:? str-id))))
                          )
                        ))
<<<<<<< HEAD

    (let ((not-used-rule1 '(
                            (:not-used (:? text-id))
                            (:used (:? text-id))
                            :!
                            :fail)
                          )
          )
=======
>>>>>>> pt-20191224-editor
      (let ((not-used-rule2 '(
                              (:not-used (:? text-id))
                              )
                            ))
        (let ((fb (cons not-used-rule1 ;; order matters!
                        (cons not-used-rule2
                              (cons add-kinds-rule (cl-event-passing-user::@get-instance-var self :fb))))))
          (arrowgrams/compiler/util::run-prolog self '((:add-kinds (:? box-id))) fb))))))
      
