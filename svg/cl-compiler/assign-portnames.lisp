
(in-package :arrowgrams/compiler)
(defclass assign-portnames (compiler-part) ())
(defmethod e/part:busy-p ((self assign-portnames)) (call-next-method))
(defmethod e/part:clone ((self assign-portnames)) (call-next-method))

; (:code ASSIGN-PORTNAMES (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self assign-portnames))
  (call-next-method))

(defmethod e/part:react ((self assign-portnames) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (state self)
      (:idle
       (if (eq pin :fb)
           (setf (fb self) data)
         (if (eq pin :go)
             (progn
               (@send self :request-fb t)
               (setf (state self) :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "ASSIGN-PORTNAMES in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (assign-portnames self)
             (@send self :done t)
             (e/part::first-time self))
         (@send
          self
          :error
          (format nil "ASSIGN-PORTNAMES in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

(defmethod assign-portnames ((self assign-portnames))
  (let ((all-port-bbs (find-all-nameless-port-bounding-boxes self)))
    (let ((all-text-bbs (find-all-unused-text-bounding-boxes self))
          (port-vs-text-hash-table (make-hash-table)))
      (dolist (port-plus-bb all-port-bbs)
        (multiple-value-bind (id left top right bottom)
            (get-port-details self port-plus-bb)
          (let ((distance-list nil))
            (dolist (text-plus-bb all-text-bbs)
              (multiple-value-bind (tid tstr tleft ttop tright tbottom)
                  (get-text-details self text-plus-bb)
                (let ((c (closest left top right bottom tleft ttop tright tbottom)))
                  (when (eq :ontop (side c))
                    (format *error-output* "~&assign-portnames warning: text ~a /~a/ on top of port ~a~%" tid tstr (first port-plus-bb)))
                  (push (list tid tstr c) distance-list))))
            (let ((closest (find-minimum self distance-list)))
              (setf (gethash id port-vs-text-hash-table) closest)))))
      (asserta-portnames self port-vs-text-hash-table))))

(defmethod asserta-portnames ((self assign-portnames) h)
  (maphash #'(lambda (port text-id-str-closest)
               (destructuring-bind (id str closest)
                   text-id-str-closest
                 (declare (ignore closest))
                 (asserta self (list :portNameByID port id) nil nil nil nil nil nil nil)
                 (asserta self (list :portName port str) nil nil nil nil nil nil nil)))
           h))

(defmethod find-all-nameless-port-bounding-boxes ((self assign-portnames))
  (let ((fb
         (append
          arrowgrams/compiler::*rules*
          (fb self))))
    (let ((goal '((:collect_nameless_ports (:? portid) (:? left) (:? top) (:? right) (:? bottom)))))
      (let ((results (run-prolog self goal fb)))
        results))))

(defmethod find-all-unused-text-bounding-boxes ((self assign-portnames))
  (let ((fb
         (append
          *rules*
          (fb self))))
    (let ((goal '((:collect_unused_text (:? textid) (:? str) (:? left) (:? top) (:? right) (:? bottom)))))
      (let ((results (run-prolog self goal fb)))
        results))))

(defmethod get-port-details ((self assign-portnames) alist)
  (declare (ignore self))
  (let ((id     (cdr (assoc 'portid alist)))
        (left   (cdr (assoc 'left   alist)))
        (top    (cdr (assoc 'top    alist)))
        (right  (cdr (assoc 'right  alist)))
        (bottom (cdr (assoc 'bottom alist))))
    (values id left top right bottom)))

(defmethod get-text-details ((self assign-portnames) plist)
  (declare (ignore self))
  (let ((id     (cdr (assoc 'textid plist)))
        (str    (cdr (assoc 'str    plist)))
        (left   (cdr (assoc 'left   plist)))
        (top    (cdr (assoc 'top    plist)))
        (right  (cdr (assoc 'right  plist)))
        (bottom (cdr (assoc 'bottom plist))))
    (values id str left top right bottom)))

(defmethod find-minimum ((self assign-portnames) list-id-vs-str-vs-distance-list)
  (declare (ignore self))
  (let ((minimum (first list-id-vs-str-vs-distance-list)))
    (dolist (triple list-id-vs-str-vs-distance-list)
      (when (less-than-p (third triple) (third minimum))
        (setf minimum triple)))
    minimum))
