(in-package :arrowgrams/clparts/ident)

;;
;; :code ident '(:in) '(:out :fatal) #'arrowgram/clparts/ident::react #'arrogram/clparts/ident::first-time
;;

;; match bracketed idents ('[' .+ ']') and send out as (cons :ident (cons <string> first-position))

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


(defmethod clear-ident ((self e/part:part))
  (@set-instance-var self :start-pos nil)
  (@set-instance-var self :ident "")
  (@set-instance-var self :pin-ident  ""))

(defmethod start-ident ((self e/part:part) data)
  (@set-instance-var self :start-pos (cdr data))
  (@set-instance-var self :ident "")
  (@set-instance-var self :pin-ident  ""))

(defmethod start-pin-ident ((self e/part:part) data)
  (declare (ignore self data))
  nil)

(defmethod append-ident ((self e/part:part) ch)
  (let ((ident-thus-far (@get-instance-var self :ident)))
    (let ((new-ident (concatenate 'string ident-thus-far (string ch))))
      (@set-instance-var self :ident new-ident))))

(defmethod append-pin-ident ((self e/part:part) ch)
  (let ((pin-ident-thus-far (@get-instance-var self :pin-ident)))
    (let ((new-ident (concatenate 'string pin-ident-thus-far (string ch))))
      (@set-instance-var self :pin-ident new-ident))))

(defun first-time (self)
  (@set-instance-var self :state :idle)
  (@set-instance-var self :ident nil))

(defun react (self e)
  ;; an event, here, is a cons (char . position), output such conses again, or, (:ident . ("string" . position))
  (let ((pin-sym (@get-pin self e))
	(data (@get-data self e)))
    (let ((ch (first data))
          (pos (cdr data)))
      
      
      (if (not (eq :in pin-sym))
          (@send self :fatal (format nil "expected input pin :in, but got ~S" pin-sym))
        
        (ecase (@get-instance-var self :state)
          
          (:idle
           (if (eq :EOF ch)
               (progn
                 (@send self :out (cons :eof pos))
                 (@set-instance-var self :state :eof))
             
             (if (char= #\[ ch)
                 (progn
                   (start-ident self data)
                   (@set-instance-var self :state :waiting-for-close-bracket))
               
               (@send self :out data))))
          
          (:waiting-for-close-bracket
           (if (eq :EOF ch)
               (progn
                 (when (@get-instance-var self :ident)
                   (let ((msg (format nil "EOF, but unfinished identifier ~S" (@get-instance-var self :ident))))
                     (@send self :fatal (format nil msg))))
                 (@send self :out (cons :eof pos)))

             (if (eq #\/ ch)
                 (progn
                   (start-pin-ident self data)
                   (@set-instance-var self :state :waiting-for-close-bracket-with-pin))
               
               (if (eq #\] ch)
                   (let ((ident (@get-instance-var self :ident))
                          (pos (@get-instance-var self :start-pos)))
                     (@send self :out (cons :ident ident))
                     (clear-ident self)
                     (@set-instance-var self :state :idle))
                 
                 (append-ident self ch)))))

          (:waiting-for-close-bracket-with-pin
           (if (eq :EOF ch)
               (progn
                 (when (@get-instance-var self :ident)
                   (let ((msg (format nil "EOF, but unfinished identifier ~S" (@get-instance-var self :ident))))
                     (@send self :fatal (format nil msg))))
                 (@send self :out (cons :eof pos)))

             (if (eq #\/ ch)
                 (@send self :fatal "FATAL in ident: expected only 0 or 1 slashes, got second slash on ident ~S" (@get-instance-var self :ident))
               
               (if (eq #\] ch)
                   (let ((ident (@get-instance-var self :ident))
                         (pin-ident (@get-instance-var self :pin-ident))
                         (pos (@get-instance-var self :start-pos)))
                     (@send self :out (cons :ident-with-pin (cons ident (cons pin-ident pos))))
                     (clear-ident self)
                     (@set-instance-var self :state :idle))
                 
                 (append-pin-ident self ch)))))
          
          (:eof
           (@send self :fatal (format nil "FATAL in ident: end of file, but received ~S ~S" pin-sym data))))))))
