
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
  (let ((all-port-bbs (find-all-port-bounding-boxes self)))
    (let ((all-text-bbs (find-all-unused-text-bounding-boxes self))
          (port-vs-text-hash-table (make-hash-table)))
      (dolist (port-plus-bb all-port-bbs)
        (multiple-value-bind (id left top right bottom)
            (get-port-details self port-plus-bb)
          (format *standard-output* "~&port ~A~%" id)
          (let ((distance-list nil))
            (dolist (text-plus-bb all-text-bbs)
              (multiple-value-bind (tid tstr tleft ttop tright tbottom)
                  (get-text-details self text-plus-bb)
                (let ((c (closest left top right bottom tleft ttop tright tbottom)))
                  (format *standard-output* "~&tid ~a tstr/~a/ side ~a distance ~a~%" tid tstr (side c) (distance c))arrowgrams/compiler/back-end
                  (push (list tid tstr c) distance-list))))
            (let ((closest (find-minimum self distance-list)))
              (format *standard-output* "~&port ~a closest ~A~%" id closest)
              (setf (gethash id port-vs-text-hash-table) closest)))))
      (asserta-portnames self port-vs-text-hash-table))))

(defmethod asserta-portnames ((self e/part:part) h)
  (maphash #'(lambda (port text-id-str-closest)
               (destructuring-bind (id str closest)
                   text-id-str-closest
                 (declare (ignore closest))
                 (arrowgrams/compiler/util::asserta self (list :portNameByID port id) nil nil nil nil nil nil nil)
                 (arrowgrams/compiler/util::asserta self (list :portName port str) nil nil nil nil nil nil nil)))
           h))

(defmethod find-all-port-bounding-boxes ((self e/part:part))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (cl-event-passing-user::@get-instance-var self :fb))))
    (let ((goal '((:collect_ports (:? portid) (:? left) (:? top) (:? right) (:? bottom)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        results))))

(defmethod find-all-unused-text-bounding-boxes ((self e/part:part))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (cl-event-passing-user::@get-instance-var self :fb))))
    (let ((goal '((:collect_unused_text (:? textid) (:? str) (:? left) (:? top) (:? right) (:? bottom)))))
      (let ((results (arrowgrams/compiler/util::run-prolog self goal fb)))
        results))))

(defmethod get-port-details ((self e/part:part) alist)
  (declare (ignore self))
  (let ((id     (cdr (assoc 'portid alist)))
        (left   (cdr (assoc 'left   alist)))
        (top    (cdr (assoc 'top    alist)))
        (right  (cdr (assoc 'right  alist)))
        (bottom (cdr (assoc 'bottom alist))))
    (values id left top right bottom)))

(defmethod get-text-details ((self e/part:part) plist)
  (declare (ignore self))
  (let ((id     (cdr (assoc 'textid plist)))
        (str    (cdr (assoc 'str    plist)))
        (left   (cdr (assoc 'left   plist)))
        (top    (cdr (assoc 'top    plist)))
        (right  (cdr (assoc 'right  plist)))
        (bottom (cdr (assoc 'bottom plist))))
    (values id str left top right bottom)))

(defmethod find-minimum ((self e/part:part) list-id-vs-str-vs-distance-list)
  (declare (ignore self))
  (let ((minimum (first list-id-vs-str-vs-distance-list)))
    (dolist (triple list-id-vs-str-vs-distance-list)
      (when (less-than-p (third triple) (third minimum))
        (setf minimum triple)))
    minimum))