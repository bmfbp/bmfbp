;;INPUTS
;; (:in <token>)  
;;
;;OUTPUTS
;; (:out <token>)
;; (:error object)       obj=(list <error-message> <string-kind> <buffer>)

(in-package :arrowgrams/parser/eol-comments)

;; find all comments that start with % and finish at the EOL
;; avoid the insides of dquote and squote strings "..." and '...'

;; :state is :idle, :in-comment, :in-dquote or :in-squote

(defmethod react ((self e/part:part) (e e/event:event))
  (let ((state (@get-instance-var self :state))
        (token (e/event:data e)))
    (let ((ty (token-type token))
          (c  (token-value token))
          (position (token-position token)))
      (if (eq ty :EOF)
          (do-eof self state token)
        (progn
          (ecase state 
            
            (:idle
             (if (char= c #\%)
                 (progn
                   (clear-buffer self)
                   (push-token-into-buffer self token)
                   (@set-instance-var self :state :in-comment))
               (if (char= c #\")
                   (progn
                     (send-token self token)
                     (@set-instance-var self :state :in-dquote))
                 (if (char= c #\')
                     (progn
                       (send-token self token)
                       (@set-instance-var self :state :in-squote))
                   (send-token self token)))))
            
            (:in-comment
             (if (char= c #\Newline) ;; eof handled above
                 (progn
                   (push-token-into-buffer self token)
                   (send-buffer self)
                   (@set-instance-var self :state :idle))
               (push-token-into-buffer self token)))
            
            (:in-dquote
             (send-token self token)
             (when (char= c #\")
               (@set-instance-var self :state :idle)))
            
            (:in-squote
             (send-token self token)
             (when (char= c #\')
               (@set-instance-var self :state :idle))))))))
  
      (send-request self)) ;; not sent if :EOF

(defmethod send-unterminated-string-error ((self e/part:part) string-type)
  (let ((err-pin (@get-output-pin self :error)))
    (let ((buffer (get-buffer self)))
      (@send self err-pin (list "unterminated string" string-type buffer))
      (clear-buffer self)
      (@set-instance-var self :state :idle))))

(defmethod send-token ((self e/part:part) token)
  (let ((out-pin (@get-output-pin self :out)))
    (@send self out-pin token)))

(defmethod clear-buffer ((self e/part:part))
  (@set-instance-var self :buffer nil))

(defmethod push-token-into-buffer ((self e/part:part) token)
  (@set-instance-var self :buffer (cons token (@get-instance-var self :buffer))))

(defmethod get-buffer ((self e/part:part))
  (let ((buffer (@get-instance-var self :buffer)))
    (reverse buffer)))

(defmethod send-buffer ((self e/part:part))
  (let ((out-pin (@get-output-pin self :out)))
    (let ((buffer (get-buffer self)))
      (when buffer
        (@send self out-pin (make-token :type :comment :value buffer :position (token-position (first buffer))))
        (clear-buffer self)))))

(defmethod send-request ((self e/part:part))
  (let ((req-pin (@get-output-pin self :request)))
    (@send self req-pin T)))

(defmethod do-eof ((self e/part:part) state eof-token)
  (send-buffer self)
  (let ((out-pin (@get-output-pin self :out)))
    (@send self out-pin eof-token)
    (case state
      (:idle
       nil)
      (otherwise
       (send-unterminated-string-error self state)))))

(defmethod first-time ((self e/part:part))
  (clear-buffer self)
  (@set-instance-var self :state :idle))

