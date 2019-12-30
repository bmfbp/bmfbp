;;INPUTS
;; (:in (token thing)) creates whitespace - compress all whitespace into a single token
;;
;;OUTPUTS
;; (:out <string>)   (:comment <string>) (:character <string) (:whitespace <string>) (:eof T)
;; (:error object)       some fatal error, "object" specifies error details
;;
;; (:code ws (:in) (:out :error) #'arrowgrams/parser/ws::react :first-time #'arrowgrams/parser/ws::first-time)

(in-package :arrowgrams/parser/ws)

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
      (ecase state

        (:idle
         (ecase ty
           (:comment
            (forward-token self token))
           (:eof
            (finalize self token))
           (:character
            (if (whitespace-char-p c)
                (progn
                  (clear-buffer self)
                  (push-token-into-buffer self token)
                  (set-state self :collecting-whitespace))
              (forward-token self token)))))

        (:collecting-whitespace
         (ecase ty
           (:comment
            (finalize-whitespace self)
            (send-token self token)
            (set-state self :idle))
           (:eof
            (finalize-eof self token)
            (set-state self :done))
           (:character
            (if (whitespace-char-p c)
                (push-token-into-buffer self token)
              (progn
                (finalize-whitespace self)
                (send-token self token)
                (set-state self :idle))))))

        (:done
         (error (format nil "whitespace received input after finishing /~S/" e)))))))

(defmethod finalize-whitespace ((self e/part:part))
  (send-buffer self))

(defmethod finalize-eof ((self e/part:part) eof-token)
  (send-buffer self)
  (send-token self eof-token))

(defmethod set-state ((self e/part:part) next-state)
  (@set-instance-var self :state next-state))

(defmethod send-buffer ((self e/part:part))
  ;; send whitespace token, reset buffer
  (let ((ws (get-buffer self)))
    (when ws
      (send-token self (make-token :type :whitespace :value ws :position (token-position (first ws)))))
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

(defun whitespace-char-p (c)
  ;; return T if c is a whitespace characater, else NIL
  (and (characterp c)
       (or
        (char= c #\Space)
        (char= c #\Tab)
        (char= c #\Newline)
        (char= c #\Return))))
        