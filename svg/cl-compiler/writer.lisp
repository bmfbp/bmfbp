(in-package :arrowgrams/compiler)

; (:code writer (:filename :start :next :no-more) (:request :error))

(defmethod writer-first-time ((self e/part:part))
  (cl-event-passing-user::@set-instance-var self :state :idle)
  (cl-event-passing-user::@set-instance-var self :filename nil)
  (cl-event-passing-user::@set-instance-var self :stream *standard-output*))

(defmethod writer-react ((self e/part:part) (e e/event:event))
  (let ((action (e/event::sym e))
        (state (cl-event-passing-user::@get-instance-var self :state)))
    (ecase state
      (:idle
       (ecase action
         (:filename
          (cl-event-passing-user::@set-instance-var self :filename (e/event:data e))
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
          (progn
            (cl-event-passing-user::@send self :error (format nil "WRITER warning: facts must be length 2 or 3, but got ~S" lfact))
            (ecase (length fact)
              (4 (format stream "~a(~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)))
              (5 (format stream "~a(~s,~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)
                         (sixth fact)))
              (6 (format stream "~a(~s,~s,~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)
                         (sixth fact) (seventh fact)))
              (7 (format stream "~a(~s,~s,~s,~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)
                         (sixth fact) (seventh fact) (eighth fact)))
              (8 (format stream "~a(~s,~s,~s,~s,~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)
                         (sixth fact) (seventh fact) (eighth fact) (ninth fact)))
              (9 (format stream "~a(~s,~s,~s,~s,~s,~s,~s,~s).~%" (first fact) (second fact) (third fact) (fourth fact) (fifth fact)
                         (sixth fact) (seventh fact) (eighth fact) (ninth fact) (tenth fact)))))
        (if (= 2 (length fact))
            (format stream "~a(~s).~%" (first fact) (second fact))
          (if (= 3 (length fact))
              (format stream "~a(~s,~s).~%" (first fact) (second fact) (third fact))))))))
  
  
