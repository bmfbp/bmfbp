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
          (setf (gethash :self parts) (list :name top-name :inputs nil :outputs nil)))))

    (let ((goal '((:find_parts (:? ID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((id (cdr (assoc 'ID result)))
                (strid (cdr (assoc 'Strid result))))
            (setf (gethash id parts) (list :name strid :inputs nil :outputs nil))))))

    (let ((goal '((:find_self_input_pins (:? PortID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((id (cdr (assoc 'ID result)))
                (strid (cdr (assoc 'Strid result))))
            (let ((plist (gethash :self parts)))
              (let ((name (getf plist :name))
                    (inputs (getf plist :inputs))
                    (outputs (getf plist :outputs)))
                (setf (gethash :self parts) (list :name name :inputs (cons strid inputs) :outputs outputs))))))))

    (let ((goal '((:find_self_output_pins (:? PortID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((id (cdr (assoc 'ID result)))
                (strid (cdr (assoc 'Strid result))))
            (declare (ignore id))
            (let ((plist (gethash :self parts)))
              (let ((name (getf plist :name))
                    (inputs (getf plist :inputs))
                    (outputs (getf plist :outputs)))
                (setf (gethash :self parts) (list :name name :inputs inputs :outputs (cons strid outputs)))))))))

#|
    (let ((goal '((:find_part_input_pins (:? RectID) (:? PortID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((rectid (cdr (assoc 'RectID result)))
                (PortID (cdr (assoc 'PortID result)))
                (strid (cdr (assoc 'Strid result))))
            (declare (ignore PortID))
            (let ((plist (gethash rectid parts)))
              (let ((name (getf plist :name))
                    (inputs (getf plist :inputs))
                    (outputs (getf plist :outputs)))
                (setf (gethash rectid parts) (list :name name :inputs (cons strid inputs) :outputs outputs))))))))

    (let ((goal '((:find_part_output_pins (:? RectID) (:? PortID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((rectid (cdr (assoc 'RectID result)))
                (PortID (cdr (assoc 'PortID result)))
                (strid (cdr (assoc 'Strid result))))
            (declare (ignore PortID))
            (let ((plist (gethash rectid parts)))
              (let ((name (getf plist :name))
                    (inputs (getf plist :inputs))
                    (outputs (getf plist :outputs)))
                (setf (gethash rectid parts) (list :name name :inputs inputs :outputs (cons strid outputs)))))))))
|#

    (maphash #'(lambda (id plist)
                 (format *standard-output* "id=~A plist=~S~%" id plist))
             parts)))
                 




