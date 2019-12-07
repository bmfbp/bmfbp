(in-package :arrowgrams/clparts/words)

;;
;; :code words '(:in) '(:out :fatal) #'arrowgram/clparts/words::react #'arrogram/clparts/words::first-time
;;

;; match bracketed wordss ('[' .+ ']') and send out as (cons :words (cons <string> first-position))

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


(defmethod clear-words ((self e/part:part))
  (@set-instance-var self :start-pos nil)
  (@set-instance-var self :word ""))

(defmethod start-words ((self e/part:part) data)
  (@set-instance-var self :start-pos (cdr data))
  (@set-instance-var self :word ""))

(defmethod append-words ((self e/part:part) ch)
  (let ((words-thus-far (@get-instance-var self :word)))
    (let ((new-word (concatenate 'string words-thus-far (string ch))))
      (@set-instance-var self :word new-word))))

(defun first-time (self)
  (@set-instance-var self :state :idle)
  (clear-words))

(defun whitespace-p (self ch)
  (declare (ignore self))
  (or (char= ch #\Space)
      (char= ch #\Newline)))

(defun lookup-keyword (self word)
  (declare (ignore self))
  (let ((kw
         ;; probably better as some kind of hash table
         (cond ((string= word "part") :part)
               ((string= word "declarations") :declarations)
               ((string= word "schematic") :schematic)
               ((string= word "code") :code)
               ((string= word "declarations") :declarations)
               ((string= word "internal") :internal)
               ((string= word "parts") :parts)
               ((string= word "input") :input)
               ((string= word "output") :output)
               ((string= word "pins") :pins)
               ((string= word "wiring") :wiring)
               (t nil)))
        (pos (@get-instance-var self :start-pos)))
    (if kw
        (@send self :out (cons kw pos))
      (@send self :out (cons :word (cons word start-pos))))))
      
(defmethod is-break-char-p ((self e/part:part) ch)
  (declare (ignore self))
  (member ch '(#\, #\: #\{ #\})))

(defmethod send-word ((self e/part:part))
  (let ((word (@get-instance-var self :word)))
    (when (not (string= "" word))
      (let ((keyword (lookup-keyword self word)))
        (if keyword
            (@send self :out `( (:type . :keyword ) (:pos . ,pos) (:text . ,keyword)))
          (@send self :out `( (:type . :word ) (:pos . ,pos) (:text . ,word))))))))

(defun react (self e)
  ;; an event, here, is a cons (char . position), or (:ident . pos) or (:ident-with-pin . (stuff)), output such conses again, or,
  ;; (:word . ("string" . position)) or (:keyword . ("string" . position))
  (let ((pin-sym (@get-pin self e))
	(data (@get-data self e)))
    (let ((ch (first data))
          (rest (cdr data)))
      
      
      (if (not (eq :in pin-sym))
          (@send self :fatal (format nil "expected input pin :in, but got ~S" pin-sym))
        
        (ecase (@get-instance-var self :state)
          
          (:idle
           (if (eq :EOF ch)
               (progn
                 (@send self :out (cons :eof rest))
                 (@set-instance-var self :state :eof))
             
             (if (break-char-p self ch)
                 (@send self :out data)

               (if (not (whitespace-p self ch))
                   (progn
                     (start-word self data)
                     (@set-instance-var self :state :collecting-characters))
                 
                 (@send self :out data)))))
          
          (:collecting-characters
           (if (eq :EOF ch)
               (progn
                 (when (@get-instance-var self :word)
                   (send-word self))
                 (@send self :out (cons :eof pos)))

             (if (eq #\/ ch)
                 (progn
                   (start-pin-words self data)
                   (@set-instance-var self :state :waiting-for-close-bracket-with-pin))
               
               (if (eq #\] ch)
                   (let ((words (@get-instance-var self :words))
                          (pos (@get-instance-var self :start-pos)))
                     (@send self :out (cons :words words))
                     (clear-words self)
                     (@set-instance-var self :state :idle))
                 
                 (append-words self ch)))))

          (:eof
           (@send self :fatal (format nil "FATAL in words: end of file, but received ~S ~S" pin-sym data))))))))
