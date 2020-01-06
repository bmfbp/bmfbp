(in-package :arrowgrams/compiler/fb)

;; create an in-memory factbase, given single facts sent in on pins :string-fact or :lisp-fact

; (:code fb (:string-fact :lisp-fact :retract :go :fb-request :iterate :get-next :show) (:fb :no-more :next :error) #'arrowgrams/compiler/db::react #'arrowgrams/compiler/db::first-time)

(defparameter *show-additions* nil)

(defmethod first-time ((self e/part:part))
  (setf *show-additions* nil)
  (cl-event-passing-user::@set-instance-var self :state :idle)
  (cl-event-passing-user::@set-instance-var self :fb-as-iterable-list nil)
  (cl-event-passing-user::@set-instance-var self :factbase nil))

(defmethod react ((self e/part:part) e)
  (flet ((idle-reaction (action state) (declare (ignorable state))
           (if (eq action :retract)
               (progn
                 (format *standard-output* "~&retract ~S~%" (e/event:data e))
                 (cl-event-passing-user::@set-instance-var
                  self
                  :factbase
                  (arrowgrams/compiler/util::remove-fact
                   (e/event:data e)
                   (cl-event-passing-user::@get-instance-var self :factbase)))
                 (cl-event-passing-user::@send self :fb (cl-event-passing-user::@get-instance-var self :factbase)))
             (if (eq action :string-fact)
                 (add-string-fact self (e/event:data e))
               (if (eq action :lisp-fact)
                   (add-lisp-fact self (e/event:data e))
                 (if (eq action :go)
                     (assert nil)
                   (if (eq action :show)
                       (setf *show-additions* (e/event:data e))
                     (if (eq action :fb-request)
                         (cl-event-passing-user::@send self :fb (cl-event-passing-user::@get-instance-var self :factbase))
                       (if (eq action :iterate)
                           (progn
                             (begin-iteration self)
                             (cl-event-passing-user::@set-instance-var self :state :iterating))
                         (cl-event-passing-user:@send self
                                                      :error
                                                      (format nil "FB in state :idle expected :retract, :string-fact, :lisp-fact, :go, :fb-request or :iterate, but got action ~S data ~S" action (e/event:data e))))))))))))
  
           (let ((action (e/event::sym e))
                 (state (cl-event-passing-user::@get-instance-var self :state)))    
             (ecase state
               (:idle
                (idle-reaction action state))
               (:idle-with-cleanup ;; might get one more request after going back to :idle
                (if (eq action :get-next)
                    (cl-event-passing-user::@set-instance-var self :state :idle)
                  (idle-reaction action state)))
        (:iterating
         (if (eq action :get-next)
             (send-next self)
           (if (eq action :iterate) ;; restart iteration from beginning
               (begin-iteration self)
             (cl-event-passing-user:@send self
                                          :error
                                          (format nil "FB in state :iterating expected :get-next or :iterate, but got action ~S data ~S"
                                                  action (e/event:data e))))))))))
  
(defmethod begin-iteration ((self e/part:part))
  (cl-event-passing-user::@set-instance-var
   self
   :fb-as-iterable-list
   (cl-event-passing-user::@get-instance-var self :factbase))
  (send-next self))

(defmethod send-next ((self e/part:part))
  (let ((fact-list (cl-event-passing-user::@get-instance-var self :fb-as-iterable-list)))
    (let ((fact (pop fact-list)))
      (cl-event-passing-user::@set-instance-var self :fb-as-iterable-list fact-list)
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
          (cl-event-passing-user:@send self :error (format nil "db: expected a list, but got ~S" fact-string))
        (add-lisp-fact self fact)))))

(defmethod add-lisp-fact ((self e/part:part) fact)
  (when *show-additions*
    (format *standard-output* "~&add-fact ~S~%" fact))
  (let ((fb (cl-event-passing-user::@get-instance-var self :factbase)))
    (let ((existing-fact-lis (find-fact fact fb)))
      (when existing-fact-lis
        (let ((existing-fact (first existing-fact-lis)))
          (if (equal existing-fact fact)
              (fb-warning self "fact already exists ~A" fact)
            (fb-error self "fact ~S attempts to override existing fact ~S" fact existing-fact))))
      (cl-event-passing-user::@set-instance-var self :factbase (cons
                                                                (cons fact nil) ;; rules are lists of lists, facts are a list of a list
                                                                fb)))))

(defmethod fb-warning ((self e/part:part) format-string &rest format-args)
  (cl-event-passing-user::@send self :error (apply #'cl:format
                                                   nil
                                                   (concatenate 'string "WARNING FB: " format-string)
                                                   format-args)))
                                
(defmethod fb-error ((self e/part:part) format-string &rest format-args)
  (cl-event-passing-user::@send self :error (apply #'cl:format
                                                   nil
                                                   (concatenate 'string "ERROR FB: " format-string)
                                                   format-args)))


(defun find-fact (fact factbase)
  (find-if #'(lambda (f-list)
               (when (= 1 (length f-list))) ;; skip over rules, examine only facts
               (let ((f (first f-list)))
                 (and (equal (first fact) (first f))
                      (equal (second fact) (second f)))))
            factbase))