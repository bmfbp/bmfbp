(in-package :arrowgrams/compiler/db)

;; create an in-memory factbase, given single facts sent in on pins :string-fact or :lisp-fact

; (:code fb (:string-fact :lisp-fact :iterate :get-next) (:no-more :next :fatal) #'arrowgrams/compiler/db::react #'arrowgrams/compiler/db::first-time)

(defmethod first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  (cl-event-passing-user::@set-instance-var self :fb-as-list nil)
  (cl-event-passing-user::@set-instance-var self :factbase nil))

(defmethod react ((self e/part:part) e)
  (flet ((idle-reaction (action state)
       (if (eq action :string-fact)
           (add-string-fact self (e/event:data e))
         (if (eq action :lisp-fact)
             (add-lisp-fact self (e/event:data e))
           (if (eq action :iterate)
               (progn
                 (begin-iteration self)
                 (cl-event-passing-user::@set-instance-var self :state :iterating))
             (cl-event-passing-user:@send self
                                          :fatal
                                          (format nil "FB in state :idle expected :string-fact, :lisp-fact or :iterate, but got action ~S data ~S" action (e/event:data e))))))))

    (let ((action (e/event::sym e))
          (state (cl-event-passing-user::@get-instance-var self :state)))    
      (ecase state
        (:idle
         (idle-reaction action state))
        (:idle-with-cleanup ;; might get one more request after going back to Lidle
         (if (eq action :get-next)
             (cl-event-passing-user::@set-instance-var self :state :idle)
           (idle-reaction action state)))
        (:iterating
         (if (eq action :get-next)
             (send-next self)
           (if (eq action :iterate) ;; restart iteration from beginning
               (begin-iteration self)
             (cl-event-passing-user:@send self
                                          :fatal
                                          (format nil "FB in state :iterating expected :get-next or :iterate, but got action ~S data ~S"
                                                  action (e/event:data e))))))))))
  
(defmethod begin-iteration ((self e/part:part))
  (cl-event-passing-user::@set-instance-var
   self
   :fb-as-list
   (cl-event-passing-user::@get-instance-var self :factbase))
  (send-next self))

(defmethod send-next ((self e/part:part))
  (let ((fact-list (cl-event-passing-user::@get-instance-var self :fb-as-list)))
    (let ((fact (pop fact-list)))
      (cl-event-passing-user::@set-instance-var self :fb-as-list fact-list)
      (if (null fact)
          (progn
            (cl-event-passing-user::@send self :no-more t)
            (cl-event-passing-user::@set-instance-var self :state :idle-with-cleanup))
        (cl-event-passing-user::@send self :next fact)))))
       
      
                           
(defmethod add-string-fact ((self e/part:part) fact-string)
  (declare (ignore self))
  (with-input-from-string (fact-stream fact-string)
    (let ((fact (read fact-stream nil :EOF)))
      (if (not (listp fact))
          (cl-event-passing-user:@send self :fatal (format nil "db: expected a list, but got ~S" fact-string))
        (add-lisp-fact self fact)))))

(defmethod add-lisp-fact ((self e/part:part) fact)
  (cl-event-passing-user::@set-instance-var self :factbase (cons fact (cl-event-passing-user::@get-instance-var self :factbase))))