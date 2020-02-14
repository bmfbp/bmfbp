(in-package :arrowgrams/compiler/classes)

(defmacro with-speechbubble-bb (id-list bb &body body)
  (declare (ignore id-list))
  `(let ((left (cdr (second ,bb)))
         (top  (cdr (third ,bb)))
         (right  (cdr (fourth ,bb)))
         (bottom  (cdr (fifth ,bb))))
     ,@body))

(defmacro with-text-bb (id-list bb &body body)
  (declare (ignore id-list))
  `(let ((id (cdr (first ,bb)))
         (left (cdr (third ,bb)))
         (top  (cdr (fourth ,bb)))
         (right  (cdr (fifth ,bb)))
         (bottom  (cdr (sixth ,bb))))
     ,@body))


