(in-package :arrowgrams/clparts/word)

;;
;; :code word '(:in) '(:out :fatal) #'arrowgram/clparts/word::react #'arrogram/clparts/word::first-time
;;

;; match bracketed words ('[' .+ ']') and send out as (cons :word (cons <string> first-position))

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


(defmethod clear-word ((self e/part:part))
  (@set-instance-var self :start-pos nil)
  (@set-instance-var self :word ""))

(defmethod start-word ((self e/part:part) character position)
  (@set-instance-var self :start-pos position)
  (@set-instance-var self :word (string character)))

(defmethod collect-character ((self e/part:part) ch)
  (let ((word-thus-far (@get-instance-var self :word)))
    (let ((new-word (concatenate 'string word-thus-far (string ch))))
      (@set-instance-var self :word new-word))))

(defmethod send-word ((self e/part:part))
  (let ((word (@get-instance-var self :word)))
    (when (not (string= "" word))
      (@send self :out `((:type . :word) (:text . ,word) (:position . ,(@get-instance-var self :start-pos)))))
    (clear-word self)))

(defun first-time (self)
  (@set-instance-var self :state :idle)
  (clear-word self))

(defun send-char-pos (self char pos)
  (@send self :out `((:type . :character) (:text . ,char) (:position . ,pos))))

(defun whitespace-p (self char)
  (declare (ignore self))
  (or
   (char= char #\Space)
   (char= char #\Newline)
   (char= char #\Return)
   (char= char #\Tab)))

(defun react (self e)
  ;; an event, here, is an alis, output such conses again, creating :keywords and :words as we find them
  (let ((pin-sym (@get-pin self e))
	(data (@get-data self e)))
    (let ((ty (cdr (assoc :type data))))
            
      (if (not (eq :in pin-sym))
          (@send self :fatal (format nil "expected input pin :in, but got ~S" pin-sym))
        
        (let ((ch (cdr (assoc :text data)))
              (pos (cdr (assoc :position data))))
          (if (not (eq ty :character))
              (@send self :out data)

            (ecase (@get-instance-var self :state)
          
              (:idle
               (if (eq :EOF ch)
                   (progn
                     (send-char-pos self :eof pos)
                     (@set-instance-var self :state :eof))
             
                 (if (not (whitespace-p self ch))
                     (progn
                       (start-word self ch pos)
                       (@set-instance-var self :state :collecting))
               
                   (send-char-pos self ch pos))))
          
              (:collecting
               (if (eq :EOF ch)
                   (progn
                     (send-word self)
                     (send-char-pos self :eof pos)
                     (@set-instance-var self :state :eof))

                 (if (whitespace-p self ch)
                     (progn
                       (send-word self)
                       (send-char-pos self #\Space pos)
                       (@set-instance-var self :state :idle))

                   (collect-character self ch))))

              (:eof
               (@send self :fatal (format nil "FATAL in word: end of file, but received ~S ~S" pin-sym data))))))))))
