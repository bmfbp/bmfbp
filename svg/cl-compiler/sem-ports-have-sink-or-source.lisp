
(in-package :arrowgrams/compiler)
(defclass sem-ports-have-sink-or-source (compiler-part) ())
(defmethod e/part:busy-p ((self sem-ports-have-sink-or-source)) (call-next-method))
(defmethod e/part:clone ((self sem-ports-have-sink-or-source)) (call-next-method))

; (:code SEM-PORTS-HAVE-SINK-OR-SOURCE (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self sem-ports-have-sink-or-source))
  (call-next-method)

(defmethod e/part:react ((self sem-ports-have-sink-or-source) e)
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
            (format nil "SEM-PORTS-HAVE-SINK-OR-SOURCE in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (setf (fb self) data)
             (format *standard-output* "~&sem-ports-have-sink-or-source~%")
             ;; put code here
             (@send self :done t)
             (e/part:first-time self))
         (@send
          self
          :error
          (format nil "SEM-PORTS-HAVE-SINK-OR-SOURCE in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

