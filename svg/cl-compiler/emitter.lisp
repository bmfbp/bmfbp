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
          (cl-event-passing-user::@get-instance-var self :fb)))
        (parts (make-hash-table)))

    (let ((goal '((:match_top_name (:? N)))))
      (let ((result (arrowgrams/compiler/util::run-prolog self goal fb)))
        (assert (and (listp result) (= 1 (length (car result)))))
        (let ((top-name (cdr (assoc 'N (car result)))))
          (format *standard-output* "~&name = ~A~%" top-name)
          (setf (gethash :self parts) (list 'name top-name 'inputs nil 'outputs nil)))))
    
    (let ((goal '((:find_parts (:? ID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((id (cdr (assoc 'ID result)))
                (strid (cdr (assoc 'Strid result))))
            (format *standard-output* "~&id = ~A strid=~a~%" id strid)
            (setf (gethash id parts) (list 'name strid 'inputs nil 'output nil))))))

    (let ((goal '((:find_self_input_pins (:? PortID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((id (cdr (assoc 'ID result)))
                (strid (cdr (assoc 'Strid result))))
            (declare (ignore id))
            (format *standard-output* "~&self input pin=~a~%" strid)
            (let ((plist (gethash :self parts)))
              (let ((name (get 'name plist))
                    (inputs (get 'inputs plist))
                    (outputs (get 'outputs plist)))
                (setf (get plist 'inputs) (list 'name name 'inputs (cons strid inputs) 'outputs outputs))))))))

    (let ((goal '((:find_self_output_pins (:? PortID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((id (cdr (assoc 'ID result)))
                (strid (cdr (assoc 'Strid result))))
            (declare (ignore id))
            (format *standard-output* "~&self output pin=~a~%" strid)
            (let ((plist (gethash :self parts)))
              (let ((name (get 'name plist))
                    (inputs (get 'inputs plist))
                    (outputs (get 'outputs plist)))
                (setf (get plist 'inputs) (list 'name name 'outputs (cons strid outputs) 'inputs inputs))))))))

    (let ((goal '((:find_part_input_pins (:? RectID) (:? PortID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((rectid (cdr (assoc 'RectID result)))
                (PortID (cdr (assoc 'PortID result)))
                (strid (cdr (assoc 'Strid result))))
            (declare (ignore PortID))
            (format *standard-output* "~&part ~A input pin=~a~%" rectid strid)
            (let ((plist (gethash rectid parts)))
              (let ((name (get 'name plist))
                    (inputs (get 'inputs plist))
                    (outputs (get 'outputs plist)))
                (setf (get plist 'inputs) (list 'name name 'inputs (cons strid inputs) 'outputs outputs))))))))

    (let ((goal '((:find_part_output_pins (:? RectID) (:? PortID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((rectid (cdr (assoc 'RectID result)))
                (PortID (cdr (assoc 'PortID result)))
                (strid (cdr (assoc 'Strid result))))
            (declare (ignore PortID))
            (format *standard-output* "~&part ~A output pin=~a~%" rectid strid)
            (let ((plist (gethash rectid parts)))
              (let ((name (get 'name plist))
                    (inputs (get 'inputs plist))
                    (outputs (get 'outputs plist)))
                (setf (get plist 'inputs) (list 'name name 'outputs (cons strid outputs) 'inputs inputs))))))))

    (maphash #'(lambda (id plist)
                 (format *standard-output* "id=~A plist=~S~%" id plist))
             parts)))
                 




