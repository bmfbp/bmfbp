;;INPUTS
;; (:in <c>)  <c> is a character or :EOF
;;
;;OUTPUTS
;; (:out <obj>)      <obj> is a character or a '(:comment <comment>)
;; (:error object)       obj=(list <error-message> <string-kind> <buffer>)
;;

(in-package :arrowgrams/parser/eol-comments)

;; find all comments that start with % and finish at the EOL
;; avoid the insides of dquote and squote strings "..." and '...'

;; :state is :idle, :in-comment, :in-dquote or :in-squote

(defmethod first-time ((self e/part:part))
  (clear-buffer self)
  (cl-event-passing-user::@set-instance-var self :state :idle))

(defmethod react ((self e/part:part) (e e/event:event))
  (let ((c (e/event:data e)))
    (ecase (cl-event-passing-user::@get-instance-var self :state)
      
      (:idle
       (if (char= c #\%)
           (progn
             (clear-buffer self)
             (push-char-into-buffer self c)
             (cl-event-passing-user::@set-instance-var self :state :in-comment))
         (if (char= c #\")
             (progn
               (clear-buffer self)
               (push-char-into-buffer self c)
               (cl-event-passing-user::@set-instance-var self :state :in-dquote))
           (if (char= c #\')
               (progn
                 (clear-buffer self)
                 (push-char-into-buffer self c)
                 (cl-event-passing-user::@set-instance-var self :state :in-squote))
             (send-char self c)))))

      (:in-comment
       (push-char-into-buffer self c)
       (when (or
              (eq c :EOF)
              (char= c #\Newline))
         (send-buffer self :comment)
         (cl-event-passing-user::@set-instance-var self :state :in-comment)))
      
     (:in-dquote
      (send-char self c)
      (when (char= c #\")
          (cl-event-passing-user::@set-instance-var self :state :idle)))
     
     (:in-squote
      (send-char self c)
      (when (char= c #\')
          (cl-event-passing-user::@set-instance-var self :state :idle)))))

  (send-request self))



(defmethod send-unterminated-string-error ((self e/part:part) string-type)
  (let ((err-pin (cl-event-passing-user::@get-output-pin self :error)))
    (cl-event-passing-user::@send self err-pin (list "unterminated string" string-type (get-buffer self)))
    (clear-buffer)
    (cl-event-passing-user::@set-instance-var self :state :idle)))

(defmethod send-char ((self e/part:part) c)
  (let ((out-pin (cl-event-passing-user::@get-output-pin self :out)))
    (cl-event-passing-user::@send self out-pin c)))

(defmethod clear-buffer ((self e/part:part))
   (cl-event-passing-user::@set-instance-var self :buffer nil))

(defmethod push-char-into-buffer ((self e/part:part) c)
  (cl-event-passing-user::@set-instance-var
   self :buffer
   (cons c (cl-event-passing-user::@get-instance-var self :buffer))))

(defmethod get-buffer ((self e/part:part))
  (reverse (cl-event-passing-user::@get-instance-var self :buffer)))

(defmethod send-buffer ((self e/part:part) token-type)
  (let ((out-pin (cl-event-passing-user::@get-output-pin self :out)))
    (let ((buff (get-buffer self)))
      (cl-event-passing-user::@send self out-pin (list token-type buff))
      (clear-buffer self))))

(defmethod send-request ((self e/part:part))
  (let ((req-pin (cl-event-passing-user::@get-output-pin self :request)))
    (cl-event-passing-user::@send self req-pin T)))
