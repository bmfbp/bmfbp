(in-package :arrowgrams/clparts/remove-ws-runs)

;;
;; :code remove-ws-runs '(:in) '(:out :fatal) #'arrowgram/clparts/remove-ws-runs::react #'arrogram/clparts/remove-ws-runs::first-time
;;

;; replace [ \t\n\t]+ by ' ', at EOF, send latest char/run the send (cons :EOF latest-char-count)
;; each input is a (cons char count), outputs are the same, except ws runs are compressed to a single (cons #\space count)
;;  where the count for a space is the first char index of a run

(defmethod @get-pin ((self e/part:part) (e e/event:event))
  (cl-event-passing-user::@get-pin self e))

(defmethod @get-data ((self e/part:part) (e e/event:event))
  (cl-event-passing-user::@get-data self e))

(defmethod @get-instance-var ((self e/part:part) name)
  (cl-event-passing-user::@get-instance-var self name))

(defmethod @set-instance-var ((self e/part:part) name val)
  (cl-event-passing-user::@set-instance-var self name val))

(defmethod @send ((self e/part:part) sym data)
  (cl-event-passing-user::@send self sym data))

(defun is-white-space-p (char)
  (or
   (char= char #\Space)
   (char= char #\Newline)
   (char= char #\Return)
   (char= char #\Tab)))


(defun first-time (self)
  (@set-instance-var self :state :idle)
  (@set-instance-var self :first-char-of-run-pos nil))

(defun send-char-pos (self char pos)
  (@send self :out `((:character . ,char) (:position . ,pos))))

(defun react (self e)
  ;; an event, here, is an alis ((:char . char) (:pos . position)), output such alists again, but kill runs of ws
  (let ((pin-sym (@get-pin self e))
	(data (@get-data self e)))
    (let ((ch (cdr (assoc :character data)))
          (current-pos (cdr (assoc :position data))))
      

      (if (not (eq :in pin-sym))
          (@send self :fatal (format nil "expected input pin :in, but got ~S" pin-sym))
        
        (ecase (@get-instance-var self :state)
          
          (:idle
           (if (eq :EOF ch)
               (progn
                 (when (@get-instance-var self :first-char-of-run)
                   (send-char-pos self :eof (@get-instance-var self :first-char-of-run-pos)))
                 (send-char-pos self :eof current-pos)
                 (@set-instance-var self :state :eof))

             (if (is-white-space-p ch)
                 (progn
                   (@set-instance-var self :first-char-of-run-pos current-pos)
                   (@set-instance-var self :state :run))
               
               (send-char-pos self ch current-pos))))

          (:run
           (if (eq :EOF ch)
               (progn
                 (when (@get-instance-var self :first-char-of-run-pos)
                   (send-char-pos self #\Space (@get-instance-var self :first-char-of-run-pos)))
                 (send-char-pos self :eof current-pos)
                 (@set-instance-var self :state :eof))

             (if (is-white-space-p ch)
                 nil
               (progn
                 (send-char-pos self #\Space (@get-instance-var self :first-char-of-run-pos))
                 (send-char-pos self ch current-pos)
                 (@set-instance-var self :state :idle)))))
          
        (:eof
         (@send self :fatal (format nil "FATAL in remove-ws-runs end of file"))))))))
  