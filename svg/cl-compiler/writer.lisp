(in-package :arrowgrams/compiler)

(defclass writer (e/part:part) ())
(defmethod e/part:busy-p ((self writer)) (call-next-method))
; (:code writer (:filename :start :next :no-more) (:request :error))

(defmethod e/part:first-time ((self writer))
  (@set self :state :idle)
  (@set self :filename nil)
  (@set self :stream *standard-output*))

(defmethod e/part:react ((self writer) (e e/event:event))
  (let ((action (e/event::sym e))
        (state (@get self :state)))
    (ecase state
      (:idle
       (ecase action
         (:filename
          (@set self :filename (e/event:data e))
          (open-stream self))
         
         (:start
          (@send self :request t)
          (@set self :state :writing))))

      (:writing
       (ecase action
         (:no-more
          (close-stream self)
          (@set self :state :idle))
         (:next
          (write-fact self (e/event:data e))
          (@send self :request t)))))))

(defmethod open-stream ((self writer))
  (let ((filename (@get self :filename)))
    (when filename
      (let ((stream (open filename :direction :output :if-exists :supersede)))
        (if stream
            (@set self :stream stream)
          (@send self :error (format nil "can't open file ~S" filename)))))))

(defmethod close-stream ((self writer))
  (let ((filename (@get self :filename))
        (stream (@get self :stream)))
    (when (and filename
               stream
               (not (eq *standard-output* stream)))
      (close stream))))
  

(defmethod write-fact ((self writer) lfact)
  (let ((stream (@get self :stream)))
    (unless (listp lfact)
      (@send self :error (format nil "facts must be a list, but got ~S" lfact)))
    (let ((fact (car lfact)))
      (if (not (or (= 3 (length fact)) (= 2 (length fact))))
          (progn
            (@send self :error (format nil "WRITER warning: facts must be length 2 or 3, but got ~S" lfact))
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
