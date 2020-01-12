
(in-package :arrowgrams/compiler/ASSIGN-PORTNAMES)

; (:code ASSIGN-PORTNAMES (:fb :go) (:add-fact :done :request-fb :error) #'arrowgrams/compiler/ASSIGN-PORTNAMES::react #'arrowgrams/compiler/ASSIGN-PORTNAMES::first-time)

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
            (format nil "ASSIGN-PORTNAMES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (cl-event-passing-user::@set-instance-var self :fb data)
             (format *standard-output* "~&assign-portnames~%")
             (assign-portnames self)
             (cl-event-passing-user::@send self :done t)
             (cl-event-passing-user::@set-instance-var self :state :idle))
         (cl-event-passing-user::@send
          self
          :error
          (format nil "ASSIGN-PORTNAMES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defstruct join
  id
  text-id
  port-id
  str-id
  distance)

(defmethod assign-portnames ((self e/part:part))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (cl-event-passing-user::@get-instance-var self :fb))))
    (let ((goal '((:collect_joins (:? join) (:? text) (:? port) (:? distance) (:? str)))))
      (let ((join-results (arrowgrams/compiler/util::run-prolog self goal fb)))
        #+nil(format *standard-output* "~&join results=~S~%" join-results)
        
        (let ((port-join-list-hash (make-hash-table))
              (text-used-up (make-hash-table))
              (port-join-hash (make-hash-table)))
          
          (mapc #'(lambda (alist)
                    (let ((port-id (cdr (assoc 'port alist)))
                          (distance (cdr (assoc 'distance alist)))
                          (text-id (cdr (assoc 'text alist)))
                          (str-id (cdr (assoc 'str alist)))
                          (join-id (cdr (assoc 'join alist))))
                      (let ((join-data (make-join :id join-id :port-id port-id :text-id text-id :str-id str-id :distance distance)))
                        (let ((list-for-port (gethash port-id port-join-list-hash)))
                          (let ((new-list (cons join-data list-for-port)))
                            (format *standard-output* "port-id ~S new-list length ~A~%" port-id (length new-list))
                            (setf (gethash port-id port-join-list-hash) new-list))))))
                join-results)
          
          (maphash #'(lambda (port-id join-list-for-port)
                       (let ((join (find-minimum-distance join-list-for-port)))
                         (format *standard-output* "~&join-data ~S~%" join)
                         (assert-text-not-used text-used-up (join-text-id join) join)
                         (setf (gethash port-id port-join-hash) join)))
                   port-join-list-hash)
          
          (asserta-portnames self port-join-hash))))))

(defun find-minimum-distance (L)
  (let ((min-join nil))
    (assert (listp L))
    (dolist (join L)
      (assert (>= (join-distance join) 0))
      (when (or (null min-join)
                (< (join-distance join) (join-distance min-join)))
            (setf min-join join)))
    min-join))
    
(defmethod asserta-portnames ((self e/part:part) h)
  (maphash #'(lambda (port join)
               (arrowgrams/compiler/util::asserta self (list :portNameByID port (join-text-id join)) nil nil nil nil nil nil nil)
               (arrowgrams/compiler/util::asserta self (list :portNameBy port (join-str-id join)) nil nil nil nil nil nil nil))
           h))

(defun assert-text-not-used (text-used-up-hash text-id join)
  (assert (not (null text-id)))
  (multiple-value-bind (val success)
      (gethash text-id text-used-up-hash)
    (when success
      (format *standard-output* "~&duplicate port name~%~S~%~S~%" val join)
      #+nil(assert nil))
    (setf (gethash text-id text-used-up-hash) join)))

