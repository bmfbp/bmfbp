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
        (parts (make-hash-table :test 'equal))
        (wires nil))

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
          (let ((id (cdr (assoc 'PortID result)))
                (strid (cdr (assoc 'Strid result))))
            (let ((plist (gethash :self parts)))
              (let ((name (getf plist :name))
                    (inputs (getf plist :inputs))
                    (outputs (getf plist :outputs)))
                (setf (gethash :self parts) (list :name name :inputs (pushnew strid inputs) :outputs outputs))))))))

    (let ((goal '((:find_self_output_pins (:? PortID) (:? Strid)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (dolist (result results)
          (let ((id (cdr (assoc 'PortID result)))
                (strid (cdr (assoc 'Strid result))))
            (declare (ignore id))
            (let ((plist (gethash :self parts)))
              (let ((name (getf plist :name))
                    (inputs (getf plist :inputs))
                    (outputs (getf plist :outputs)))
                (setf (gethash :self parts) (list :name name :inputs inputs :outputs (pushnew strid outputs)))))))))

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
                (setf (gethash rectid parts) (list :name name :inputs (pushnew strid inputs) :outputs outputs))))))))

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
                (setf (gethash rectid parts) (list :name name :inputs inputs :outputs (pushnew strid outputs)))))))))

    (format *standard-output* "~&~%edges~%")
    (let ((goal '((:find_wire (:? RectID1) (:? PortID1) (:? PortName1) (:? RectID2) (:? PortID2) (:? PortName2)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb))
            (edges nil))
        (dolist (result results)
          (let ((rectid1 (cdr (assoc 'RectID1 result)))
                (PortID1 (cdr (assoc 'PortID1 result)))
                (name1 (cdr (assoc 'PortName1 result)))
                (rectid2 (cdr (assoc 'RectID2 result)))
                (PortID2 (cdr (assoc 'PortID2 result)))
                (name2 (cdr (assoc 'PortName2 result))))
            (let ((edge `(,rectid1 ,name1 ,rectid2 ,name2)))
              (format *standard-output* "~&edge ~s ~s --> ~s ~s~%~S~%" rectid1 name1 rectid2 name2 edge)
              (push edge edges))))

        (let ((wires (collapse-fan-out edges)))

          (format *standard-output* "~&~%parts~%")
          (maphash #'(lambda (id plist)
                       (format *standard-output* "id=~A plist=~S" id plist)
                   parts)
        
        (let ((self-plist (gethash :self parts)))
          (let (( final `("self" ,(getf self-plist :inputs) ,(getf self-plist :outputs) ,(make-parts-list parts) ,wires)))
            (format *standard-output* "~&final: ~S~%" final)))))))))

(defun make-parts-list (parts-hash)
  (delete :self
          (loop for key being the hash-keys of parts-hash
                collect key)))

(defclass memo-bag ()
  (seen-list :initiform nil :accessor seen-cons-list))

(defmethod seen-p ((self memo-bag) part pin)
  (member-if #'(lambda (cns)
                 (and (eq (car cns) part)
                      (eq (cdr cnd) pin)))
             (seen-list self)))

(defmethod memorize ((self memo-bag) part pin)
  (push (cons part pin) (seen-list self)))

(defun return-all-matching-edges (edge-list part pin)
  (delete nil
          (mapcar #'(lambda (edge)
                      (if (and (eq part (first edge))
                               (eq pin (second edge)))
                          edge
                        nil))
                  edge-list)))
                               
(defun collapse-fan-out (edges)
  ;; combine all edges into one, that have the same source part+pin
  ;;return a list of lists ((source-part source-pin) ((sink-part sink-pin) (sink-part sink-pin) ...))
  (let ((result nil)
        (original edges)
        (memo (make-instance 'memo-bag)))
    (@:loop
      (@:exit-when (null original))
      (let ((edge (pop original)))
        (let ((source-part (first edge))
              (source-pin  (second edge)))
          (when (not (seen-p memo (source-part source-pin)))
            (memorize memo source-part source-pin)
            (let ((wire (return-all-matching-edges edges source-part source-pin)))
              (push wire result))))))
    result))

              
