;;INPUTS
;; (:in-string <string>) only when :idle, receives a string
;; (:request) only when :emitting-characters, sends one character for each request
;;
;;OUTPUTS
;; (:out (:character c NN))  outputs character tokens (:CHARACTER c NN) where NN is the character index, or (:EOF #\Newline NN)
;; (:error object)       some fatal error, "object" specifies error details
;;
;; (:code chars (:in-string :request) (:out :error)
;;  :react #'arrowgrams/parser/chars::react
;;  :first-time #'arrowgrams/parser/chars::first-time)

(in-package :arrowgrams/parser/chars)

(defmethod first-time ((self e/part:part))
  (@set-instance-var self :state :idle)
  (@set-instance-var self :position 1)
  (@set-instance-var self :stream nil))

(defmethod react ((self e/part:part) (e e/event:event))
  (let ((data (e/event:data e))
        (action (e/event::sym e)))

    (ecase (@get-instance-var self :state)
      (:idle
       (ecase action
         (:in-string
          (@set-instance-var self :stream (make-string-input-stream data))
          (send-a-char self)
          (@set-instance-var self :state :emitting-characters))))
      
      (:emitting-characters
       (ecase action
         (:request
          (send-a-char self))))
 
      (:almost-done
       (ecase action
         (:request ;; one more straggling request is expected
          (@set-instance-var self :state :done))))

      (:done
       (send-error self (format nil "CHARS: no more characters at position ~a" (@get-instance-var self :position)))))))

(defmethod send-error ((self e/part:part) message)
  (@send self :error message))

(defmethod send-a-char ((self e/part:part))
  (let ((stream (@get-instance-var self :stream))
        (position (@get-instance-var self :position))
        (out-pin (@get-output-pin self :out)))
    (let ((c (read-char stream nil :EOF)))
      (if (eq :EOF c)
          (progn
            (@send self out-pin (make-token :type :EOF :value #\Newline :position position))
            (@set-instance-var self :state :almost-done))
          (@send self out-pin (make-token :type :character :value c :position position)))
      (@set-instance-var self :position (1+ position)))))
