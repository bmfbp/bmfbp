(in-package :arrowgrams/compiler/writer)

; (:code writer (:filename :start :next :no-more) (:request :error) #'arrowgrams/compiler/db::react #'arrowgrams/compiler/db::first-time)

(defmethod first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  (cl-event-passing-user::@set-instance-var self :filename nil)
  (cl-event-passing-user::@set-instance-var self :stream *standard-output*))

(defmethod react ((self e/part:part) (e e/event:event))
  (let ((action (e/event::sym e))
        (state (cl-event-passing-user::@get-instance-var self :state)))
    (ecase state
      (:idle
       (ecase action
         (:filename
          (cl-event-passing-user::@set-instance-var self :filname (e/event:data e))
          (open-stream self))
         
         (:start
          (cl-event-passing-user::@send self :request t)
          (cl-event-passing-user::@set-instance-var self :state :writing))))

      (:writing
       (ecase action
         (:no-more
          (close-stream self)
          (cl-event-passing-user::@set-instance-var self :state :idle))
         (:next
          (write-fact self (e/event:data e))
          (cl-event-passing-user::@send self :request t)))))))

(defmethod open-stream ((self e/part:part))
  (let ((filename (cl-event-passing-user::@get-instance-var self :filename)))
    (when filename
      (let ((stream (open filename :direction :output :if-exists :supersede)))
        (if stream
            (cl-event-passing-user::@set-instance-var self :stream stream)
          (cl-event-passing-user::@send self :error (format nil "can't open file ~S" filename)))))))

(defmethod close-stream ((self e/part:part))
  (let ((filename (cl-event-passing-user::@get-instance-var self :filename))
        (stream (cl-event-passing-user::@get-instance-var self :stream)))
    (when (and filename
               stream
               (not (eq *standard-output* stream)))
      (close stream))))
  

(defmethod write-fact ((self e/part:part) lfact)
  (let ((stream (cl-event-passing-user::@get-instance-var self :stream)))
    (unless (listp lfact)
      (cl-event-passing-user::@send self :error (format nil "facts must be a list, but got ~S" lfact)))
    (let ((fact (car lfact)))
      (if (not (or (= 3 (length fact)) (= 2 (length fact))))
          (cl-event-passing-user::@send self :error (format nil "facts must be length 2 or 3, but got ~S" lfact))
        (if (= 2 (length fact))
            (format stream "~a(~a).~%" (first fact) (second fact))
          (if (= 3 (length fact))
              (format stream "~a(~a,~a).~%" (first fact) (second fact) (third fact))))))))
  
  
