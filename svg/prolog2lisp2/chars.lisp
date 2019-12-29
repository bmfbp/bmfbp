;;INPUTS
;; (:in-string <string>) only when :idle, receives a string
;; (:request) only when :emitting-characters, sends one character for each request
;;
;;OUTPUTS
;; (:out <char>)  either a character or :EOF
;; (:error object)       some fatal error, "object" specifies error details
;;
;; (:code chars (:in-string :request) (:out :error)
;;  :react #'arrowgrams/parser/chars::react
;;  :first-time #'arrowgrams/parser/chars::first-time)

(in-package :arrowgrams/parser/chars)

(defmethod first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  (cl-event-passing-user::@set-instance-var self :string nil))

(defmethod react ((self e/part:part) (e e/event:event))
  (let ((data (e/event:data e))
        (action (e/event::sym e)))

    (ecase (cl-event-passing-user::@get-instance-var self :state)
      (:idle
       (ecase action
         (:in-string
          (let ((str (cl-event-passing-user::@set-instance-var self :string data))
                (vec (make-array (length data) :element-type 'character :adjustable t :fill-pointer 0)))
            (with-input-from-string (s str)  ;; this is ridiculous - TODO rewrite to be more efficient
              (let (c)
                (@:loop
                  (setf c (read-char s nil :EOF))
                  (@:exit-when (eq :EOF c))
                  (vector-push-extend c vec))))
            (cl-event-passing-user::@set-instance-var self :string vec)
            (send-a-char self)
            (cl-event-passing-user::@set-instance-var self :state :emitting-characters)))))
      
      (:emitting-characters
       (ecase action
         (:request
          (send-a-char self))))
 
      (:done
       (send-error self "CHARS: no more characters")))))

(defmethod send ((self e/part:part) c)
  (cl-event-passing-user::@send self :out c))

(defmethod send-error ((self e/part:part) message)
  (cl-event-passing-user::@send self :error message))

(defmethod send-a-char ((self e/part:part))
  (let ((string-vector (cl-event-passing-user::@get-instance-var self :string)))
    (if (zerop (fill-pointer string-vector))
        (progn
          (send self :EOF)
          (cl-event-passing-user::@set-instance-var self :state :done))
      (let ((c (vector-pop string-vector)))
        (send self c)))))
