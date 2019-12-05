(in-package :arrowgrams/clparts/comments-to-end-of-line)

;;
;; :code comments-to-end-of-line '(:in) '(:out :fatal) #'arrowgram/clparts/comments-to-end-of-line::react #'arrogram/clparts/comments-to-end-of-line::first-time
;;

;; a comment in arrowgrams/pseudo is "%.*$"  (%, any char until EOL or EOF)

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


(defun first-time (self)
  (@set-instance-var self :state :idle)
  (@set-instance-var self :char-count 0))

(defun react (self e)
  ;; an event, here, is a single character, we output a cons (char . position)
  (let ((pin-sym (@get-pin self e))
	(data (@get-data self e)))

    (@set-instance-var self :char-count (1+ (@get-instance-var self :char-count)))
    
    (if (not (eq :in pin-sym))
        (@send self :fatal (format nil "expected input pin :in, but got ~S" pin-sym))
      
      (ecase (@get-instance-var self :state)
        
        (:idle
         (if (eq :EOF data)
             (progn
               (@send self :out (cons :eof (@get-instance-var self :char-count)))
               (@set-instance-var self :state :eof))
           (if (char= #\% data)
               (@set-instance-var self :state :slurping-comment)
             (progn
               (@send self :out (cons data (@get-instance-var self :char-count)))))))
        
        (:slurping-comment
         (if (char= #\Newline data)
             (progn
               (@send self :out (cons #\Newline (@get-instance-var self :char-count)))
               (@set-instance-var self :state :idle))
           nil)) ;; no-op on any other char
        
        (:eof
         (@send self :fatal (format nil "end of file")))))))
  
    ;; otherwise - fail - something is terribly wrong, we should see a char on the input (if it is %, then we goto :slurping-comment, else we just forward the character on)
       
  
