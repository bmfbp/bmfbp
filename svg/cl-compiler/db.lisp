(in-package :arrowgrams/compiler/db)

;; create an in-memory factbase, given single facts sent in on pins :string-fact or :lisp-fact

(defmethod first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :factbase nil))

(defmethod react ((self e/part:part) e)
  (let ((action (e/event::sym e)))
      (if (eq action :string-fact)
          (if (eq (e/event:data e) :EOF)
              (cl-event-passing-user:@send self :done (cl-event-passing-user::@get-instance-var self :factbase))
            (add-string-fact self (e/event:data e)))
        (if (eq action :lisp-fact)
            (add-lisp-fact self (e/event:data e))
          (cl-event-passing-user:@send self
                                       :fatal
                                       (format nil "expected :string-fact or :lisp-fact (or :EOF), but got action ~S data ~S" action (e/event:data e)))))))
                           
(defmethod add-string-fact ((self e/part:part) fact-string)
  (declare (ignore self))
  (with-input-from-string (fact-stream fact-string)
    (let ((fact (read fact-stream nil :EOF)))
      (if (not (listp fact))
          (cl-event-passing-user:@send self :fatal (format nil "db: expected a list, but got ~S" fact-string))
        (add-lisp-fact self fact)))))

(defmethod add-lisp-fact ((self e/part:part) fact)
  (cl-event-passing-user::@set-instance-var self :factbase (cons fact (cl-event-passing-user::@get-instance-var self :factbase))))
