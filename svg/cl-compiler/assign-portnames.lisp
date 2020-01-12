
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

(defmethod assign-portnames ((self e/part:part))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (cl-event-passing-user::@get-instance-var self :fb))))
    (let ((goal '((:collect_joins (:? join) (:? text) (:? port) (:? distance) (:? str)))))
      (let ((join-results (arrowgrams/compiler/util::run-prolog self goal fb)))
        (format *standard-output* "~&join results=~S~%" join-results)
        
        (let ((port-list-hash (make-hash-table))
              (text-used-up (make-hash-table))
              (port-text-hash (make-hash-table))
              (port-str-hash  (make-hash-table)))
          
          (mapc #'(lambda (j)
                    (destructuring-bind (join-id text-id port-id distance str-id)
                        j
                      (let ((list-for-port (gethash port-id port-list-hash)))
                        (let ((new-list (cons (list distance text-id str-id join-id) list-for-port)))
                          (setf (gethash port-id port-list-hash) new-list)))))
                join-results)
          
          (maphash #'(lambda (port-id list-for-port)
                       (multiple-value-bind (text-id str-id)
                           (find-minimum-distance list-for-port)
                         (assert-text-not-used text-used-up text-id)
                         (setf (gethash port-id port-text-hash) text-id)
                         (setf (gethash port-id port-str-hash)  str-id)))
                   port-list-hash)
          
          (asserta-portname self port-text-hash)
          (asserta-portstr  self port-str-hash))))))

(defun assert-text-not-used (text-used-up-hash text-id)
  (assert (not (null text-id)))
  (multiple-value-bind (val success)
      (gethash text-id text-used-up-hash)
    (declare (ignore val))
    (assert (not success))
    (setf (gethash text-id text-used-up-hash) text-id)))

(defun find-minimum-distance (L)
  (let ((min-dist -1)
        (min-text nil)
        (min-str nil))
    (assert (listp L))
    (dolist (al L)
      (assert (listp al))
      (assert (= 4 (length al)))
      (destructuring-bind (distance-cons text-cons str-cons join-cons)
          (car al)
        (declare (ignore join))
        (let ((distance (cdr distance-cons))
              (text (cdr text-cons))
              (str (cdr str-cons))
              (join (cdr join-cons)))
          (assert (>= distance 0))
          (when (< distance min-dist)
            (setf min-dist distance
                  min-text text
                  min-str str))))
      (values min-text min-str))))
    
(defmethod asserta-portname ((self e/part:part) h)
  (maphash #'(lambda (port text)
               (arrowgrams/compiler/util::asserta self (list :portNameByID port text) nil nil nil nil nil nil nil))
           h))

(defmethod asserta-portstr ((self e/part:part) h)
  (maphash #'(lambda (port strid)
               (arrowgrams/compiler/util::asserta self (list :portName port strid)    nil nil nil nil nil nil nil))
           h))

