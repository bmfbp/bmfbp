;;INPUTS
;; (:in <token>) creates unsigned interger [0-9]+ tokens or passes tokens through
;;
;;OUTPUTS
;; (:out <string>)   {type:uint, value:int, position:NN}
;; (:error object)       some fatal error, "object" specifies error details
;;
;; (:code uint (:in) (:out :error) #'arrowgrams/parser/uint::react #'arrowgrams/parser/uint::first-time)

(in-package :arrowgrams/parser/uint)

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
           (if (uint-p c)
               (progn
                 (clear-buffer self)
                 (push-token-into-buffer self token)
                 (set-state self :collecting-uint)))
           (forward-token self token))

          (:collecting-uint
           (if (uint-p c)
               (push-token-into-buffer self token)
             (progn
               (finish self)
               (@set-instance-var self :state :idle))))
          
          (:done
           (error (format nil "uint is finished, but received /~S/" token))))))))

(defmethod finish ((self e/part:part))
  (send-if-buffer self)
  (@set-instance-var self :state :done))

(defmethod set-state ((self e/part:part) next-state)
  (@set-instance-var self :state next-state))

(defmethod send-if-buffer ((self e/part:part))
  (let ((buffer (get-buffer self)))
    (when buffer
      (send-token self (make-token :type :uint :value buffer :position (token-position (first buffer)))))
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

(defun uint-p (c)
  ;; return T if c is [0-9], else NIL
  (and (characterp c)
       (case c
         ((#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)
          t)
         (otherwise nil))))

