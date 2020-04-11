;;INPUTS
;; (:in <token>) creates :ident tokens, which match [A-Za-z_][A-Za-z0-9_]*
;; NB. Prolog differentiates Logic Variables from tokens by leading upper case letter, this will be handled later
;; NB. Prolog includes a number of keywords, these will be handled later
;;
;;OUTPUTS
;; (:out <string>)   {type :ident, value:token-buffer, position:NN}
;; (:error object)       some fatal error, "object" specifies error details
;;
;; (:code ident (:in) (:out :error) #'arrowgrams/parser/ident::react #'arrowgrams/parser/ident::first-time)

(in-package :arrowgrams/parser/ident)

(defmethod first-time ((self e/part:part))
  (set-state self :idle)
  (clear-buffer self))

(defmethod react ((self e/part:part) (e e/event:event))
  (let ((token (e/event:data e))
        (action (e/event::sym e))
        (state (@get-instance-var self :state)))
    (assert (eq action :in))
    (let ((ty (token-type token))
          (c (token-value token)))             
      (if (not (eq :character ty))

          (progn
            (send-if-buffer self)
            (forward-token self token)
            (when (eq :EOF ty)
              (finish self)))
        
        (ecase state
          
          (:idle
           (if (first-ident-p c)
               (progn
                 (clear-buffer self)
                 (push-token-into-buffer self token)
                 (set-state self :collecting-ident)))
           (forward-token self token))

          (:collecting-ident
           (if (follow-ident-p c)
               (push-token-into-buffer self token)
             (progn
               (finish self)
               (@set-instance-var self :state :idle))))
          
          (:done
           (error (format nil "ident is finished, but received /~S/" token))))))))

(defmethod finish ((self e/part:part))
  (send-if-buffer self)
  (@set-instance-var self :state :done))

(defmethod set-state ((self e/part:part) next-state)
  (@set-instance-var self :state next-state))

(defmethod send-if-buffer ((self e/part:part))
  (let ((buffer (get-buffer self)))
    (when buffer
      (send-token self (make-token :type :ident :value buffer :position (token-position (first buffer)))))
    (clear-buffer self)))

(defmethod clear-buffer ((self e/part:part))
  (@set-instance-var self :buffer nil))

(defmethod send-token ((self e/part:part) token)
  (let ((out-pin (@get-output-pin self :out)))
    (@send self out-pin token)))

(defmethod forward-token ((self e/part:part) token)
  (send-token self token))

(defmethod push-token-into-buffer ((self e/part:part) token)
  (@set-instance-var self :buffer (cons token (@get-instance-var self :buffer))))

(defmethod get-buffer ((self e/part:part))
  (reverse (@get-instance-var self :buffer)))

(defun first-ident-p (c)
  ;; return T if c is [A-Za-z_], else NIL
  (or
   (alphanumericp c)
   (char= #\_ c)))

(defun follow-ident-p (c)
  ;; return T if c is [A-Za-z0-9_], else NIL
  (or
   (alphanumericp c)
   (char= #\_ c)))

