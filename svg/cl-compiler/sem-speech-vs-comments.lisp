
(in-package :arrowgrams/compiler)
(defclass sem-speech-vs-comments (e/part:part) ())
(defmethod e/part:busy-p ((self sem-speech-vs-comments)) (call-next-method))

; (:code SEM-SPEECH-VS-COMMENTS (:fb :go) (:add-fact :done :request-fb :error))

(defmethod e/part:first-time ((self sem-speech-vs-comments))
  (@set self :state :idle))

(defmethod e/part:react ((self sem-speech-vs-comments) e)
  (let ((pin (e/event::sym e))
        (data (e/event:data e)))
    (ecase (@get self :state)
      (:idle
       (if (eq pin :fb)
           (@set self :fb data)
         (if (eq pin :go)
             (progn
               (@send self :request-fb t)
               (@set self :state :waiting-for-new-fb))
           (@send
            self
            :error
            (format nil "SEM-SPEECH-VS-COMMENTS in state :idle expected :fb or :go, but got action ~S data ~S" pin (e/event:data e))))))

      (:waiting-for-new-fb
       (if (eq pin :fb)
           (progn
             (@set self :fb data)
             (format *standard-output* "~&sem-speech-vs-comments~%")
             ;; put code here
             (@send self :done t)
             (@set self :state :idle))
         (@send
          self
          :error
          (format nil "SEM-SPEECH-VS-COMMENTS in state :waiting-for-new-fb expected :fb, but got action ~S data ~S" pin (e/event:data e))))))))

